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
PREFIX  = arm-dolce-eabi
CC      = $(PREFIX)-gcc
CXX		= $(PREFIX)-g++
AR      = $(PREFIX)-gcc-ar


ARCH	:=	-mtune=cortex-a9 -mfpu=neon
CFLAGS	:=	-g -Wl,-q -O3 -ffunction-sections \
			$(ARCH) $(DEFINES)
CFLAGS	+=	$(INCLUDE) -DVITA -D__VITA__ -DLIB_RW -DRW_GLES2 -DRW_GL3 -DGLFW_INCLUDE_ES2 -DAUDIO_OAL #-DLIBRW_GLAD
CXXFLAGS	:= $(CFLAGS) -fno-rtti -fno-exceptions
ASFLAGS	:=	-g $(ARCH)
LDFLAGS	=	-g $(ARCH) -Wl,-Map,$(notdir $*.map)
LIBS	:=   -lrw -lglfw3 -lpib -lopenal -llibScePiglet_stub -lSceShaccCg_stub -ltaihen_stub -lSceLibKernel_stub -lSceKernelThreadMgr_stub \
				-lSceKernelModulemgr_stub -lSceSysmodule_stub -lSceIofilemgr_stub -lSceGxm_stub \
				-lSceCtrl_stub -lSceHid_stub -lSceAudio_stub -lSceTouch_stub -lm -lpthread -mpg123


all: $(TARGET).vpk

%.vpk: eboot.bin
	@$(PREFIX)strip -g $<
	@dolce-mksfoex -s TITLE_ID="$(DOLCE_TITLEID)" "$(DOLCE_APPNAME)" $(BUILD_DIR)/sce_sys/param.sfo
	@dolce-pack-vpk -s $(BUILD_DIR)/sce_sys/param.sfo -b $(BUILD_DIR)/eboot.bin \
		--add $(BUILD_DIR)/sce_sys=sce_sys \
		$(TARGET).vpk

eboot.bin: $(TARGET).velf
	dolce-make-fself -s $< $@

%.velf: %.elf
	dolce-elf-create -h 4194304 $< $@

$(TARGET).elf: $(OBJS)
	$(CXX) $(CXXFLAGS) $< $(LIBS) -o $@

clean:
	@rm -rf $(TARGET).vpk $(TARGET).velf $(TARGET).elf $(OBJS) \
		$(BUILD_DIR)/eboot.bin $(BUILD_DIR)/sce_sys/param.sfo