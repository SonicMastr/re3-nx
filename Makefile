TARGET		:= RE3
BUILD_DIR	:= build
# re3 files
SOURCES		:= src src/animation src/audio src/audio/oal src/audio/eax src/control src/core src/entities src/math src/modelinfo src/objects src/peds src/render src/rw src/save src/skel src/skel/glfw src/text src/vehicles src/weapons src/extras src/fakerw
DATA		:=	data
INCLUDES	:= src src/animation src/audio src/audio/oal src/audio/eax src/control src/core src/entities src/math src/modelinfo src/objects src/peds src/render src/rw src/save src/skel src/skel/glfw src/text src/vehicles src/weapons src/extras src/fakerw librw

CFILES		:=	$(foreach dir,$(SOURCES),$(wildcard $(dir)/*.c))
CPPFILES	:=	$(foreach dir,$(SOURCES),$(wildcard $(dir)/*.cpp))
#SFILES		:=	$(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.s)))
BINFILES	:=	$(foreach dir,$(DATA),$(wildcard $(dir)/*.*))
OBJS     := $(CFILES:.c=.o) $(addsuffix .o,$(BINFILES)) $(CPPFILES:.cpp=.o)

INCLUDE	:=	$(foreach dir,$(INCLUDES),-I$(dir))

DOLCEAPPNAME := RE3
DOLCE_TITLEID := RE3000001
DOLCEVERSION := 01.00
PREFIX  = arm-dolce-eabi
CC      = $(PREFIX)-gcc
CXX		= $(PREFIX)-g++
AR      = $(PREFIX)-gcc-ar


ARCH	:=	-mtune=cortex-a9 -mfpu=neon
CFLAGS	:=	-g -Wl,-q -ffunction-sections -fpermissive -fno-lto\
			$(ARCH) $(DEFINES)
CFLAGS	+=	$(INCLUDE) -DVITA -D__VITA__ -DMASTER -DFINAL -DLIBRW -DRW_GLES2 -DRW_GL3 -DGLFW_INCLUDE_ES2 -DAUDIO_OAL -DNO_MOVIES#-DLIBRW_GLAD
CXXFLAGS	:= $(CFLAGS) -fno-rtti -fno-threadsafe-statics
LDFLAGS	=	-g $(ARCH) -Wl,-Map,$(notdir $*.map)
LIBS	:=  -lrw -lglfw3 -lpib -lopenal -lSDL2 -lvita2d -lSceDisplayUser_stub -lSceDisplay_stub -lSceCommonDialog_stub -lSceLibKernel_stub -lSceThreadmgr_stub \
				-lSceModulemgr_stub -lSceSysmodule_stub -lSceIofilemgr_stub -lSceGxm_stub \
				-lSceCtrl_stub -lSceHid_stub -lSceAudio_stub -lSceTouch_stub -lm -lpthread -lmpg123


all: $(TARGET).vpk

%.vpk: eboot.bin
	dolce-mksfoex -s TITLE_ID=$(DOLCE_TITLEID) -s APP_VER=$(DOLCEVERSION) -s VERSION=$(DOLCEVERSION) -s CONTENT_ID=HB0000-$(DOLCE_TITLEID)_00-$(DOLCE_TITLEID)0000000 $(DOLCEAPPNAME) param.sfo
	dolce-make-pkg -f vpk -t app -a eboot.bin eboot.bin -a param.sfo sce_sys/param.sfo $(TARGET).vpk

eboot.bin: $(TARGET).velf
	dolce-make-fself -c $< $@

%.velf: %.elf
	dolce-elf-create -h 128194304 $< $@

$(TARGET).elf: $(OBJS)
	$(CXX) $(CXXFLAGS) $^ $(LIBS) -o $@

clean:
	@rm -rf $(TARGET).vpk $(TARGET).velf $(TARGET).elf $(OBJS) \
		eboot.bin sce_sys/param.sfo