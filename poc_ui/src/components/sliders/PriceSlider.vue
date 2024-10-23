<template>
	<div class="slider-container">
		<div class="labels">
			<span class="left-label">Affordable</span>
			<span class="right-label">Luxury</span>
		</div>
		<input type="range" min="3000" max="10000" step="100" :value="modelValue" @input="updateValue" />
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