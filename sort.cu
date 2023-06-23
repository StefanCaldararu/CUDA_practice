#include <stdio.h>
#include <stdlib.h>
#define N = 1000000
//This merge just 
__global__ void compare_and_swap(double * smaller, double larger){
    
}

int main(){
    double *arr;
    double *d_arr;
    arr = (double*) malloc(sizeof(double)*N);
    cudaMalloc((void**)&d_arr, sizeof(double)*N);
    //Initialize the array values...
    //TODO:
    //Transfer the memory
    //TODO:
    //call the merge. threads will have their own id. for each iteration,
    //we also pass some value n which is the size of the array.
    for(int i = 1;i <N;i = i*2){
        //First, calculate the TOTAL number of threads that we think we need. This will be N/i...
        int totalThreads = N/i;
        int threadsPerBlock = min(1024, totalThreads);
        if (threadsPerBlock == 1024){
            int blocks = (totalThreads+1023)/1024;
            merge<<<blocks,1024>>>(d_arr, i);
        }
        else
            merge<<<1, threadsPerBlock>>>(d_arr, i);
    }
}


int min(int a, int b) {
    return (a < b) ? a : b;
}