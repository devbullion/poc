<template>
	<div class="slider-container">
		<div class="labels">
			<span class="left-label">Cozy</span>
			<span class="right-label">Spacious</span>
		</div>
		<input type="range" min="10" max="150" step="1" :value="modelValue" @input="updateValue" />
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