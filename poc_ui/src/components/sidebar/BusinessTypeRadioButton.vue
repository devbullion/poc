<template>
    <label class="radio is-size-6 has-text-weight-medium">
        <div class="is-size-7 radio-text">
            {{ getLangText(this.lang, this.labelDict) }}
        </div>

        <input 
            type="radio" 
            :value="value" 
            :checked="modelValue === value"
            @change="$emit('update:modelValue', value)"
            :disabled="disabled"
        />
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
import { getLangText } from '../../utils/lang_utils';

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