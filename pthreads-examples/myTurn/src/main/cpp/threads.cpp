#include <chrono>
#include <cstdint>
#include <cstdio>
#include <thread>

#include <pthread.h>

void* myturn(void *arg) {
    const int N = 8;
    for (int i = 0; i < N; i++) {
        std::this_thread::sleep_for(std::chrono::seconds(1));
        printf("My Turn! %d/%d\n", i+1, N);
    }
    return NULL;
}

void yourturn() {
    const int N = 3;
    for (int i = 0; i < N; i++) {
        std::this_thread::sleep_for(std::chrono::seconds(2));
        printf("Your Turn! %d/%d\n", i+1, N);
    }
}

int main(int argc, char** argv) {
    pthread_t newthread;
    pthread_create(&newthread, NULL, myturn, NULL);
    //myturn();    
    yourturn();
    pthread_join(newthread, NULL);
    return 0;
}
