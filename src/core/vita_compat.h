#ifdef VITA

#ifdef __cplusplus
extern "C" {
#endif
    #define DIGITALRATE 48000 
    #define PATH_MAX 1024
    #define NAME_MAX 31
    #define CLOCK_MONOTONIC 0

	// Fore allocations override

	void *sceLibcMalloc(size_t size);
	void sceLibcFree(void *ptr);
	void *sceLibcCalloc(size_t nitems, size_t size);
	void *sceLibcRealloc(void *ptr, size_t size);
	void *sceLibcMemalign(size_t blocksize, size_t bytes);

    int _vita_getcwd(char *buf, size_t size);
    char *realpath(const char *name, char *resolved);
    int _vita_clock_gettime(int clk_id, struct timespec *tp);
#ifdef __cplusplus
}
#endif

#endif