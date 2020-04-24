#include <string>

#include <jitify/jitify.hpp>

#define JITABLE(code) std::string program_source =  

#ifndef RUNTIME
#include <string>
std::string program_source = R"FOO( #if false
#endif

    
    template<int N, typename T>
    __global__
    void my_kernel(T* data) {
        T data0 = data[0];
        for( int i=0; i<N-1; ++i ) {
            data[0] *= data0;
        }
    };
#ifndef RUNTIME
)FOO";
#endif

int main()
{
    static jitify::JitCache kernel_cache;
    jitify::Program program = kernel_cache.program(program_source);
    int data[3] = {1,2,3};
    dim3 grid(1);
    dim3 block(1);
    using jitify::reflection::type_of;
    program.kernel("my_kernel")
        .instantiate(3, type_of(*data))
        .configure(grid, block)
        .launch(data);
}