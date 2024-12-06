<template>
  <div class="slider-container">
    <!-- The slider itself -->
    <div class="control">
      <input 
        type="range" 
        min="10" max="150" step="1"
        :value="modelValue" 
        @input="updateValue" 
        name="slider"
      />
    </div>

    <!-- Labels below the slider -->
    <label class="labels">
      <span class="left-label">
        <div class="is-size-6 has-text-weight-medium">
          {{ getLangText(lang, {"en":"Cozy","ja":""}) }}
        </div>
      </span>
      <span class="right-label">
        <div class="is-size-6 has-text-weight-medium">
          {{ getLangText(lang, {"en":"Spacious","ja":""}) }}
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
  methods: {
    getLangText,
    updateValue(event) {
      //console.log("Slider updated to: "+event.target.value +" and emitted");
      this.$emit('update:modelValue', parseFloat(event.target.value));
    }
  }
};
</script>