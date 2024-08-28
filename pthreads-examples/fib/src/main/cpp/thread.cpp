#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <ctime>
#include <iostream> // cout
//#include <thread>
//#include <sys/types.h>

#include <pthread.h>

#include "thread.h"

static int g_tid = 0;

static int fib(int n) {
    switch (n) {
        case 0: return 1;
        case 1: return 1;
        default: return (fib(n-2) + fib(n-1));
    }
}

void* thread_proc(void* ctx) {
    int tid = g_tid++;

    char thread_name[16];
    sprintf(thread_name, "Thread %d", tid);
#ifdef __APPLE__
    pthread_setname_np(thread_name);
#else
# ifdef _WIN32
    // not available in pthreads-win32 library
# else
    pthread_setname_np(pthread_self(), thread_name);
# endif
#endif

    // Random delay, 0 - 0.5 sec
    int nsec = 500000000 + ((float)rand() / (float)RAND_MAX) * 500000000;
    std::this_thread::sleep_for(std::chrono::nanoseconds(nsec));

    volatile int i = 0;
    while (i <= 30) {
        std::cout << "Thread " << tid << ": fib(" << i << ") = " << fib(i) << std::endl;
        i++;
        nsec = 500000000 + ((float)rand() / (float)RAND_MAX) * 500000000;
        std::this_thread::sleep_for(std::chrono::nanoseconds(nsec));
    }

    std::cout << thread_name << " exited!" << std::endl;

    return NULL;
}
