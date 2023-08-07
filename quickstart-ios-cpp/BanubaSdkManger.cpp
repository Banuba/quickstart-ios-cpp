extern "C"
{
#include "BanubaSdkManager.h"
}

#include <bnb/recognizer/interfaces/all.hpp>
#include <bnb/effect_player/interfaces/all.hpp>

using std::shared_ptr;
using std::vector;
using std::string;
using namespace bnb;
using namespace bnb::interfaces;

extern "C" struct BanubaSdkManager
{
    shared_ptr<effect_player> effectPlayer;

    BanubaSdkManager()
        : effectPlayer{effect_player::create(
              effect_player_configuration::create(
                  720 /*fx_width*/,
                  1280 /*fx_height*/
              )
          )}
    {
        effectPlayer->surface_created(720, 1280);
    }
};

extern "C" void BanubaSdkManager_initialize(
    const char** pathToResources,
    const char* clientToken)
{
    vector<string> paths;
    while (*pathToResources) {
        paths.push_back(*pathToResources);
        pathToResources++;
    }
    utility_manager::initialize(paths, clientToken);
}

extern "C" void BanubaSdkManager_deinitialize()
{
    utility_manager::release();
}

extern "C" BanubaSdkManager* BanubaSdkManager_create()
{
    auto sdk = new BanubaSdkManager;
    return sdk;
}

extern "C" void BanubaSdkManager_setMetalLayer(
    BanubaSdkManager* sdk,
    RenderSurface* surface)
{
    bnb::interfaces::surface_data data(
        surface->gpuDevicePtr,
        surface->commandQueuePtr,
        surface->surfacePtr
    );
    sdk->effectPlayer->effect_manager()->set_render_surface(data);
}

extern "C" void BanubaSdkManager_loadEffect(
    BanubaSdkManager* sdk,
    const char* effectPath,
    bool synchronous)
{
    if (synchronous) {
        sdk->effectPlayer->effect_manager()->load(effectPath);
    } else {
        sdk->effectPlayer->effect_manager()->load_async(effectPath);
    }
}

extern "C" void* BanubaSdkManager_processPhoto(
    BanubaSdkManager* sdk,
    const void* rgbaIn,
    int width,
    int height)
{
    vector<uint8_t> image(
        static_cast<const uint8_t*>(rgbaIn),
        static_cast<const uint8_t*>(rgbaIn) + width * height * 4);
    const auto processed = sdk->effectPlayer->process_image_data(
        image,
        width,
        height,
        interfaces::camera_orientation::deg_0,
        /*is_mirrored*/ false,
        /*input_format*/ pixel_format::rgba,
        /*output_format*/ pixel_format::bgra);

    void* result = ::malloc(width * height * 4);
    std::memcpy(result, processed.data(), width * height * 4);
    return result;
}

extern "C" void BanubaSdkManager_destroy(BanubaSdkManager* sdk)
{
    delete sdk;
}
