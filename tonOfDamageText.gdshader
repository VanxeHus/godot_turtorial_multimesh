shader_type canvas_item;

uniform sampler2DArray numbersTex : filter_nearest;
uniform int maxNumBit = 2;
uniform float textureGap = 32.0;
uniform bool isDebug = true;
uniform vec4 testData = vec4(128, 3, 1, 1.0);
varying vec4 custom_data;

float getDigitValue(float number, int digit) {
    // Take absolute value of number
    float absNumber = abs(number);
    
    // Calculate the power of 10 for the specified digit
    float powerOf10 = pow(10.0, float(digit));
    
    // Extract the digit value using integer division and modulo
    float digitValue = mod(floor(absNumber / powerOf10), 10.0);
    
    return digitValue;
}

void vertex() {
	custom_data = INSTANCE_CUSTOM;
}

void fragment() {
    float uvX = UV.x * float(maxNumBit) * textureGap;

    float numberBit = isDebug ? testData.g : custom_data.g;
    float currentNum = isDebug ? testData.r : custom_data.r;
    float maxNumUV = numberBit * textureGap;
    if (uvX > maxNumUV){
        discard;
    }
    int numIndex = int(ceil(uvX / textureGap));
    float num = getDigitValue(currentNum, int(numberBit) - numIndex);
	float textureX = uvX / textureGap;
	vec3 numTextureUV = vec3(fract(textureX), 1.0 - UV.y, float(num));
    COLOR = texture(numbersTex, numTextureUV);
}