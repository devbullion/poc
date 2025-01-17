<template>
    <label class="radio column is-size-6 has-text-weight-medium">
        <!-- Text above the radio button -->
        <div v-if="getLangText(this.lang, this.labelDict).length <= 5" class="is-size-7 radio-text">
            {{ getLangText(this.lang, this.labelDict) }}
        </div>
        <div v-else class="small-radio-text">
            {{ getLangText(this.lang, this.labelDict) }}
        </div>

        <!-- The Radio button -->
        <input 
            type="radio" 
            :value="value" 
            @change="$emit('update:modelValue', value)"

            :checked="modelValue === value"
            :disabled="disabled"
        />
        <!-- The image for the radio button -->
        <div class="radio-img-container">
            <span v-if="disabled" class="radio-img-text-overlay">Coming Soon</span>
            <img 
                class="is-size-7"
                :src="getImageSrc('icons/business/icon_' + this.value +'_'+ this.color +'.png')"
                :alt="getLangText(this.lang, this.labelDict)"
            >
        </div>
    </label>
</template>

<script>
import { getLangText } from '@utils/lang_utils';

export default{
    props: {
        value: {type: String, required: true },
        modelValue: {type: String, required: true },

        disabled: {type: Boolean, required: true, default: false },
        lang: {type: String, required: true, default: 'en' },
        color: {type: String, required: false, default: 'black' },
        labelDict: {type: Object, required: true, default: () => ({}) }
    },
    methods: {
        getLangText,
        getImageSrc(imagePath) {
        try {
            return require("@/assets/images/"+imagePath);
        } catch (error) {
            return ''; // Return an empty string or a fallback image path
        }
        },
    }
}
</script>