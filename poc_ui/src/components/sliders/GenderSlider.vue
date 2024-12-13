<template>
	<div class="slider-container">
    <!-- The Title -->
    <div class="slider-title-label slider-title-label is-size-6 has-text-weight-semibold">
      {{ 
        getLangText(
          lang, 
          {
            "en": "Who do you think your customers will be?",
            "ja": "あなたの顧客は誰にしたいですか？" 
          }
        ) 
      }}
    </div>

    <!-- The slider itself -->
    <div class="control">
      <input 
        type="range" 
        min="0" max="1" step="0.01" 
        :value="modelValue" 
        @input="updateValue" 
        name="slider"
      />
    </div>

    <!-- Labels below the slider -->
    <label class="labels">
      <span class="slider-left-label">
        <div class="is-size-7 has-text-weight-medium">
          {{ percentageMale +"% " + getLangText(lang, {"en":"M","ja":"男性"}) }}
        </div>
      </span>
      <span class="slider-right-label">
        <div class="is-size-7 has-text-weight-medium">
          {{ percentageFemale +"% " + getLangText(lang, {"en":"F","ja":"女性"}) }}
        </div>
      </span>
    </label>

  </div>
</template>

<script>
import { getLangText } from '../../utils/lang_utils';

export default {
  props: {
    debug: {type: Boolean, required: false, default: false},
    lang: {type: String, required: false, default: "en"},
    modelValue: {type: Number, required: true}
  },
  computed: {
    percentageMale(){
      return (this.modelValue*100).toFixed(0);
    },
    percentageFemale(){
      return (100-this.modelValue*100).toFixed(0);
    },
    tooltipContent() {
      return `${(this.modelValue * 100).toFixed(0)}%`;
    }
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