#include <stereokit.h>
#include <stereokit_ui.h>
using namespace sk;

mesh_t     cube_mesh;
material_t cube_mat;
pose_t     cube_pose = {{0,0,-0.5f}, quat_identity};

sk_settings_t app_settings = {"SKNativeTemplate"};

int app_main(int argc, char **argv) {
	app_settings.assets_folder = "Assets";
	app_settings.mode          = app_mode_xr;
	if (!sk_init(app_settings))
		return 1;

    cube_mesh = mesh_gen_rounded_cube(vec3_one * 0.1f, 0.02f, 4);
    cube_mat  = material_find        (default_id_material_ui);

    sk_run([]() {
        ui_handle_begin("Cube", cube_pose, mesh_get_bounds(cube_mesh), false);
        render_add_mesh(cube_mesh, cube_mat, matrix_identity);
        ui_handle_end();
	});

    return 0;
}