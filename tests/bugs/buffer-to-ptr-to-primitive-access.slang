// TEST(compute):COMPARE_COMPUTE_EX(filecheck-buffer=CHECK):-vk -compute -shaderobj -output-using-type

public struct WrapperData
{
    int data1;
    int data2;
};

public struct Wrapper
{
    int data1;
    WrapperData* ptr;
};

//TEST_INPUT: set gdata = new Wrapper { 1, new WrapperData { 2, 3 } }
RWStructuredBuffer<Wrapper> gdata;

//TEST_INPUT: set outputBuffer = out ubuffer(data=[0 0 0 0], stride=4)
RWStructuredBuffer<float4> outputBuffer;

[shader("compute")]
[numthreads(1,1,1)]
void computeMain()
{
    gdata[0].ptr[0].data2 = 3;
    GroupMemoryBarrierWithGroupSync();
    //CHECK: 3
    outputBuffer[0] = gdata[0].ptr[0].data2;
}

