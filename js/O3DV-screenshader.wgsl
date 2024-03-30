//mesh shader

@group(0) @binding(0) var<storage> layar:array<u32>;

@vertex fn vs(
	data:masuk,
) -> hasil {
	let pos = unimat.mat*vec4f(data.pos,1.,);//xyzw
	return hasil(
		pos,
		pos,
	);
}

@fragment fn fs(
	parh: hasil //parameter hasil
) -> @location(0) vec4f {
	//discard; //sampe sini
var cobaaa = layar[3];
	return vec4f(
		vec3f(
			parh.tex.z
			/parh.tex.w
		),
		.5,
	);
}
