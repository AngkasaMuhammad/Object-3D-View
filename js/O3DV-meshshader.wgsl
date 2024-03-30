//mesh shader

struct masuk{
	@location(0) pos : vec3f,//xyz
	@location(1) tex : vec2f,
	@location(2) voroidx : u32,
}
struct hasil{
	@builtin(position) pos: vec4f,
	@location(0) tex:vec2f,
	@location(1) @interpolate(flat) voroidx:u32,
}
struct datamat{
	mat:mat4x4f,
}
			
@group(0) @binding(0) var<uniform> unimat: datamat;
@group(0) @binding(1) var<storage,read_write> layar:array<f32>;
@group(0) @binding(2) var<storage> ulain: array<u32>;
@group(0) @binding(3) var<storage> vorotail: array<u32>; //voronoi
@group(0) @binding(4) var<storage> voropos: array<vec2f>;
@group(0) @binding(5) var<storage> vorocolor: array<u32>;

@vertex fn vs(
	data:masuk,
) -> hasil {
	let pos = unimat.mat*vec4f(data.pos,1.,);//xyzw
	return hasil(
		pos,
		data.tex,
		data.voroidx,//unpack4x8unorm(bitcast<u32>(data.color)).abgr,
		
	);
}

@fragment fn fs(
	parh: hasil //parameter hasil
) -> @location(0) vec4f {
/*========
--------*/
/*========
	let depth = 
		parh.tex.z
		/parh.tex.w
	;
	return vec4f(
		0,
		parh.colorh,
		depth,
		.5,
	);
--------*/
	var min = .0;//minimum distance
	var colorini = vec4f(.5);
	//batas buffer voronoi
	let voroidx = parh.voroidx;
	let awal = select(vorotail[voroidx-1u],0u,voroidx == 0u,);
	let akhir = vorotail[voroidx];
	
	var mulai = true;
	for(var i = awal;i < akhir;i++){//sampe sini
		let d = distance(voropos[i],parh.tex,);
		if(mulai || min > d){
			mulai = false;
			min = d;
			colorini = unpack4x8unorm(vorocolor[i]).abgr;
		}
	}
	let w = ulain[0];
	let h = ulain[1];
	let ilayar =
		u32(parh.pos.x)
		+u32(parh.pos.y)*w
	;
	var blip =
		sin(layar[ilayar]*111.3)
		+layar[ilayar+1u]
		+sin(parh.pos.x+parh.pos.y*11.03)
		+2.41
	;
	blip = blip%1.;
	layar[ilayar] = blip;
	if(colorini.a < blip){
		discard;
	}
	return colorini;
}
