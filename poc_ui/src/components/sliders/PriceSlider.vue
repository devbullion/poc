<template>
	<div class="slider-container">
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
        <div class="is-size-6 has-text-weight-medium">Affordable</div>
      </span>
      <span class="right-label">
        <div class="is-size-6 has-text-weight-medium">Luxury</div>
      </span>
    </label>
  </div>
</template>

<script>
export default {
  props: {
    modelValue: {
      type: Number,
      required: true
    }
  },
  methods: {
    updateValue(event) {
      //console.log("Slider updated to: "+event.target.value +" and emitted");
      this.$emit('update:modelValue', parseFloat(event.target.value));
    }
  }
};
</script>