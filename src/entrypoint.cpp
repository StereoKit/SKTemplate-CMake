#include <stereokit.h>
using namespace sk;

extern int app_main(int argc, char **argv);
extern sk_settings_t app_settings;

#if defined(__ANDROID__)

#include <android_native_app_glue.h>

void android_main(struct android_app* state) {
    app_settings.android_activity = state->activity->clazz;
	app_settings.android_java_vm  = state->activity->vm;
    app_main(0, nullptr);

   /* while (1) {
        // Event loop goes here
        int ident;
        int events;
        struct android_poll_source* source;

        while ((ident=ALooper_pollAll(-1, NULL, &events, (void**)&source)) >= 0) {
            if (source != NULL) {
                source->process(state, source);
            }

            // Check if we are exiting.
            if (state->destroyRequested != 0) {
                return;
            }
        }
    }*/
}

#else

int main(int argc, char **argv) {
    return app_main(argc, argv);
}

#endif