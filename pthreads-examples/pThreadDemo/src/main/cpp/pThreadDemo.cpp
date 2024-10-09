#include <cstdint>
#include <cstdio>

#include <pthread.h>

const int NUM_THREAD = 5;

void *PrintHello(void *threadId) {
    uintptr_t tid = *static_cast<int*>(threadId);
    printf("hello, I am thread %lu\n", tid); // %lld
    pthread_exit(NULL);
    return NULL;
}

int main(int argc, char** argv) {
    pthread_t thread[NUM_THREAD];
    int rc;
    for (uintptr_t t = 0; t < NUM_THREAD; t++) {
        printf("Creating thread %lu\n", t);  // %lld
        rc = pthread_create(&thread[t], NULL, PrintHello, (void*)t);
    }
    return 0;
}
