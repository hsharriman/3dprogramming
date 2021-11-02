uniform vec2 resolution;
uniform float time;
uniform sampler2D map;

//uses most of the StackGL methods
//https://github.com/stackgl

//https://github.com/hughsk/glsl-square-frame

vec2 squareFrame(vec2 screenSize) {
  vec2 position = 2.0 * (gl_FragCoord.xy / screenSize.xy) - 1.0;
  position.x *= screenSize.x / screenSize.y;
  return position;
}

//https://github.com/stackgl/glsl-look-at/blob/gh-pages/index.glsl

mat3 calcLookAtMatrix(vec3 origin, vec3 target, float roll) {
  vec3 rr = vec3(sin(roll), cos(roll), 0.0);
  vec3 ww = normalize(target - origin);
  vec3 uu = normalize(cross(ww, rr));
  vec3 vv = normalize(cross(uu, ww));
  return mat3(uu, vv, ww);
}

//https://github.com/stackgl/glsl-camera-ray

vec3 getRay(mat3 camMat, vec2 screenPos, float lensLength) {
  return normalize(camMat * vec3(screenPos, lensLength));
}
vec3 getRay(vec3 origin, vec3 target, vec2 screenPos, float lensLength) {
  mat3 camMat = calcLookAtMatrix(origin, target, 0.0);
  return getRay(camMat, screenPos, lensLength);
}

/////////////////////////////////////////////////////////////////////////

mat3 rotationMatrix3(vec3 axis, float angle)
{
    axis = normalize(axis);
    float s = sin(angle);
    float c = cos(angle);
    float oc = 1.0 - c;

    return mat3(oc * axis.x * axis.x + c,           oc * axis.x * axis.y - axis.z * s,  oc * axis.z * axis.x + axis.y * s,
                oc * axis.x * axis.y + axis.z * s,  oc * axis.y * axis.y + c,           oc * axis.y * axis.z - axis.x * s,
                oc * axis.z * axis.x - axis.y * s,  oc * axis.y * axis.z + axis.x * s,  oc * axis.z * axis.z + c          );
}


vec2 sphere( vec3 p, float radius )
{
    float d = length( p ) - radius;
    return vec2(d,1);
}


const int steps = 80;

vec2 field( vec3 position )
{
    vec2 sph = sphere( position, 5. );
    return sph;
}

/////////////////////////////////////////////////////////////////////////

// the methods below this need the field function

/////////////////////////////////////////////////////////////////////////


//the actual raymarching from:
//https://github.com/stackgl/glsl-raytrace/blob/master/index.glsl

vec2 raymarching( vec3 rayOrigin, vec3 rayDir, float maxd, float precis ) {

    float latest = precis * 2.0;
    float dist   = 0.0;
    float type   = -1.0;
    vec2  res    = vec2(-1.0, -1.0);
    for (int i = 0; i < steps; i++) {

        if (latest < precis || dist > maxd) break;

        vec2 result = field( rayOrigin + rayDir * dist );
        latest = result.x;
        type   = result.y;
        dist  += latest;
    }

    if (dist < maxd) { res = vec2(dist, type); }
    return res;
}

//https://github.com/stackgl/glsl-sdf-normal

vec3 calcNormal(vec3 pos, float eps) {
  const vec3 v1 = vec3( 1.0,-1.0,-1.0);
  const vec3 v2 = vec3(-1.0,-1.0, 1.0);
  const vec3 v3 = vec3(-1.0, 1.0,-1.0);
  const vec3 v4 = vec3( 1.0, 1.0, 1.0);

  return normalize( v1 * field( pos + v1*eps ).x +
                    v2 * field( pos + v2*eps ).x +
                    v3 * field( pos + v3*eps ).x +
                    v4 * field( pos + v4*eps ).x );
}

vec3 calcNormal(vec3 pos) {
  return calcNormal(pos, 0.002);
}


void main() {


       vec3 color = vec3( 0.4, 0.8, 0.99 );    //blue
       vec2  screenPos    = squareFrame( resolution );
       float col = pow( max( 0., 1.- length( screenPos - vec2( 0.,.35 ) ) ), 1.5 );
       gl_FragColor = vec4( vec3( col ), 1. );


       float cameraAngle   = 0.2;
       float cameraRadius = 20.;
       float lensLength   = 2.5;
       float y = cameraRadius * .38 + ( cameraRadius * .32 * sin(cameraAngle) );
       vec3  rayOrigin    = vec3( cameraRadius * sin(cameraAngle), y, cameraRadius * cos(cameraAngle));
       vec3  rayTarget    = vec3(0, 0, 0);
       vec3  rayDirection = getRay(rayOrigin, rayTarget, screenPos, lensLength);


       float maxDist = 50.;
       vec2 collision = raymarching( rayOrigin, rayDirection, maxDist, .01 );

       if ( collision.x > -0.5)
       {

           //"world" position
           vec3 pos = rayOrigin + rayDirection * collision.x;

           //diffuse color
           vec3 col = vec3(0.5569, 0.6235, 1.0);

           //normal vector
           vec3 nor = calcNormal( pos );

           vec3 lig1 = normalize( vec3( 0.0, 5.0, -0.0) );
           vec3 light1 = max( 0.0, dot( lig1, nor) ) * color;

          //  float dep = ( ( collision.x + .5 ) / ( maxDist * .5 ) );
           gl_FragColor = vec4( ( col + light1  ), 1. ); // GLSL variable fed to THREE.js

       }


}