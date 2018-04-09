#include <iostream>
#include <cuda.h>

using namespace std;

__global__ 
void dkernel(int *arr, int N){
	unsigned id = blockIdx.x * blockDim.x + threadIdx.x;
	while(id < N)
	{
		arr[id] = 0;
		id += blockDim.x * gridDim.x ;
	}
}

__global__
void dkernel_add(int *arr, int N)
{
	unsigned id = blockIdx.x * blockDim.x + threadIdx.x;
	while (id < N)
	{
		arr[id] += id;
		id += blockDim.x *  gridDim.x;
	}
}

int main() {
	int *gpuArray, *cpuArray;
	//int *cpuArray = new int[32];
	cudaMallocManaged(&cpuArray, 32*sizeof(int));
	
	cudaMallocManaged(&gpuArray, 32*sizeof(int));
	dkernel<<<1, 32>>>(gpuArray,32);
	cudaMemcpy(cpuArray, gpuArray, 32*sizeof(int), cudaMemcpyDeviceToHost);
	
	for (int i = 0; i < 32 ; i++)
	{
		cout <<"cpuArray["<<i<<"]"<<cpuArray[i]<< endl;
	}

	cudaMallocManaged(&gpuArray, 1024*sizeof(int));
	dkernel<<<1, 1024>>>(gpuArray, 1024);
	dkernel_add<<<1, 1024>>>(gpuArray, 1024);
	//cpuArray = new int[1024];
	cudaMallocManaged(&cpuArray, 1024*sizeof(int));
	cudaMemcpy(cpuArray, gpuArray, 1024*sizeof(int), cudaMemcpyDeviceToHost);
	for (int i = 0 ; i < 1024 ; i++)
	{
		cout << "cpuArray["<<i<<"]"<< cpuArray[i] << endl;
	}
	
	cudaMallocManaged(&gpuArray, 8000*sizeof(int));
	dkernel<<<8000/128, 128>>>(gpuArray, 8000);
	dkernel_add<<<8000,128>>>(gpuArray, 8000);
	cpuArray = new int[8000];
	cudaMemcpy(cpuArray, gpuArray, 8000*sizeof(int), cudaMemcpyDeviceToHost);

	for(int i = 0; i < 8000 ; i++) 
	{
		cout << "cpuArray["<<i<<"]" << cpuArray[i] << endl;
	}

}
