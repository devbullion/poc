<template>
	<div class="slider-container">
		<div class="labels">
			<span class="left-label">{{ percentageMale }}% M</span>
			<span class="right-label">{{ percentageFemale }}% F</span>
		</div>
		<input type="range" min="0" max="1" step="0.01" :value="modelValue" @input="updateValue" />
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
  computed: {
	percentageMale(){
		return (this.modelValue*100).toFixed(0);
	},
	percentageFemale(){
		return (100-this.modelValue*100).toFixed(0);
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