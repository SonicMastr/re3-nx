#ifdef VITA

#ifdef __cplusplus
extern "C" {
#endif
    #define DIGITALRATE 48000 
    #define PATH_MAX 1024
    #define NAME_MAX 31
    #define CLOCK_MONOTONIC 0

    int _vita_getcwd(char *buf, size_t size);
    char *realpath(const char *name, char *resolved);
    int _vita_clock_gettime(int clk_id, struct timespec *tp);
#ifdef __cplusplus
}
#endif

#endif