#include <stereokit.h>
#include <stereokit_ui.h>

#include "floor.hlsl.h"

using namespace sk;

shader_t   floor_shader;
material_t floor_mat;
mesh_t     floor_mesh;

mesh_t     cube_mesh;
material_t cube_mat;
pose_t     cube_pose = {{0,0,-0.5f}, quat_identity};

int main(void) {
	sk_settings_t settings = {};
	if (!sk_init(settings))
		return 1;

	floor_mesh   = mesh_find        (default_id_mesh_cube);
	floor_shader = shader_create_mem((void*)sks_floor_hlsl, sizeof(sks_floor_hlsl));
	floor_mat    = material_create  (floor_shader);
	material_set_transparency(floor_mat, transparency_blend);

	cube_mesh = mesh_gen_rounded_cube(vec3_one * 0.1f, 0.02f, 4);
	cube_mat  = material_find        (default_id_material_ui);

	sk_run([]() {
		if (device_display_get_type() == display_type_flatscreen) { 
			mesh_draw(floor_mesh, floor_mat, matrix_ts({0,-1.5f,0}, {30,0.1f,30}));
		}

		ui_handle_begin("Cube", cube_pose, mesh_get_bounds(cube_mesh), false);
		render_add_mesh(cube_mesh, cube_mat, matrix_identity);
		ui_handle_end();

	}, []() {
		shader_release  (floor_shader);
		mesh_release    (floor_mesh);
		material_release(floor_mat);
		mesh_release    (cube_mesh);
		material_release(cube_mat);
	});

	return 0;
}