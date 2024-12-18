<template>
	<div class="slider-container">
    <!-- The Title -->
    <div class="slider-title-label is-size-6 has-text-weight-semibold">
      {{ 
        getLangText(
          lang, 
          {
            "en": "How would you describe your brand?",
            "ja": "コンセプト (ブランド) はどうしたいですか？" 
          }
        ) 
      }}
    </div>

    <!-- The slider itself -->
    <div class="control">
      <input 
        type="range" 
        min="3000" max="10000" step="100" 
        :value="modelValue" 
        @input="updateValue" 
        name="slider"
      />
    </div>

    <!-- Labels below the slider -->
    <label class="labels">
      <span class="left-label">
        <div class="is-size-7 has-text-weight-medium">
          {{ getLangText(lang, {"en":"Affordable","ja":"手頃な価格"}) }}
        </div>
      </span>
      <span class="right-label">
        <div class="is-size-7 has-text-weight-medium">
          {{ getLangText(lang, {"en":"Luxury","ja":"贅沢"}) }}
        </div>
      </span>
    </label>
  </div>
</template>

<script>
import { getLangText } from '../../../utils/lang_utils';

export default {
  props: {
    debug: {type: Boolean, required: false, default: false},
    lang: {type: String, required: false, default: "en"},
    modelValue: {type: Number, required: true}
  },
  methods: {
    getLangText,
    updateValue(event) {
      //console.log("Slider updated to: "+event.target.value +" and emitted");
      this.$emit('update:modelValue', parseFloat(event.target.value));
    }
  }
};
</script>