#include <stdio.h>
#include <stdlib.h>
#define N 10000000

__global__ void vector_add(float *out, float *a, float *b, int n) {
    int tid = blockIdx.x * blockDim.x + threadIdx.x;
    if(tid<=n)
        out[tid] = a[tid] + b[tid];
}


int main(){
    float *a, *b, *out; 
    float *d_a, *d_b, *d_out;

    // Allocate memory
    a   = (float*)malloc(sizeof(float) * N);
    b   = (float*)malloc(sizeof(float) * N);
    out = (float*)malloc(sizeof(float) * N);

    // Allocate GPU memory
    cudaMalloc((void**)&d_a, sizeof(float) * N);
    cudaMalloc((void**)&d_b, sizeof(float) * N);
    cudaMalloc((void**)&d_out, sizeof(float) * N);

    // Initialize array
    for(int i = 0; i < N; i++){
        a[i] = 1.0f; b[i] = 2.0f;
    }

    // Transfer data to device memory
    cudaMemcpy(d_a, a, sizeof(float) * N, cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, b, sizeof(float) * N, cudaMemcpyHostToDevice);

    // Main function
    vector_add<<<N/256,256>>>(d_out, d_a, d_b, N);

    ///sync the device before grabbing memory
    cudaDeviceSynchronize();

    //return the out array
    cudaMemcpy(out, d_out, sizeof(float) * N, cudaMemcpyDeviceToHost);

    //cleanup
    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_out);

    printf("%f\n",out[1]);
    
    //more cleanup
    free(a);
    free(b);
    free(out);
}
