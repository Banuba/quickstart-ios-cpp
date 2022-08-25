#pragma once

typedef struct BanubaSdkManager BanubaSdkManager;

typedef struct
{
    long long int gpuDevicePtr;
    long long int commandQueuePtr;
    long long int surfacePtr;
} RenderSurface;

void BanubaSdkManager_initialize(
    const char** pathToResources,
    const char* clientToken);

void BanubaSdkManager_deinitialize(void);

BanubaSdkManager* BanubaSdkManager_create(void);

void BanubaSdkManager_setMetalLayer(BanubaSdkManager* sdk, RenderSurface* surface);

void BanubaSdkManager_loadEffect(
    BanubaSdkManager* sdk,
    const char* effectPath,
    bool synchronous);

void* BanubaSdkManager_processPhoto(
    BanubaSdkManager* sdk,
    const void* rgbaIn,
    int width,
    int height);

void BanubaSdkManager_destroy(BanubaSdkManager* sdk);
