<template>
	<div class="slider-container">
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
      <span class="left-label">
        <div class="is-size-6 has-text-weight-medium">{{ percentageMale }}% M</div>
      </span>
      <span class="right-label">
        <div class="is-size-6 has-text-weight-medium">{{ percentageFemale }}% F</div>
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
    updateValue(event) {
      //console.log("Slider updated to: "+event.target.value +" and emitted");
      this.$emit('update:modelValue', parseFloat(event.target.value));
    }
  }
};
</script>