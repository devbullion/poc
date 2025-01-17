<template>
    <div 
      class = "sidebar-container"
      :class="{ closed: isClosed }"
    >
    <!-- Title -->
    <label class = "sidebar-title-container title is-5">
        {{ getLangText(
            this.lang, 
            {
            "en": "What kind of business do you want to open?",
            "ja": "どんなビジネスをしますか？"
            }) 
        }}
    </label>

    <!-- Radio Buttons -->
    <div class="radio-container is-mobile-height is-tablet-height">
        <RadioButton v-for="button in radioButtons"
        :key="button.value"
        :value="button.value" 
        v-model="localModelValue.businessType" 

        :lang="lang" 
        :labelDict="button.label"
        :disabled="button.disabled"
        />
    </div>

    <!-- Sliders -->
    <div class ="field">
        <GenderSlider v-model="localModelValue.genderValue" :lang="lang" :debug="debug"/>
    </div>
    <div class ="field">
        <SizeSlider v-model="localModelValue.sizeValue" :lang="lang" :debug="debug"/>
    </div>
    <div class ="field">
        <PriceSlider v-model="localModelValue.priceValue" :lang="lang" :debug="debug" />
    </div>

    <!-- Swipe Handle -->
    <div
        class="swipe-handle is-hidden-desktop"
        @touchstart.passive="handleTouchStart"
        @touchmove.passive="handleTouchMove"
        @touchend.passive="handleTouchEnd"

        @mousedown="handleMouseDown"
        @mousemove="handleMouseMove"
        @mouseup="handleMouseUp"
    >
      {{isClosed ? "▼" : "▲"}}
    </div>
  </div>
</template>

<script>
import { getLangText } from '@utils/lang_utils';
import GenderSlider from '@components/sidebar/sliders/GenderSlider.vue';
import SizeSlider from '@components/sidebar/sliders/SizeSlider.vue';
import PriceSlider from '@components/sidebar/sliders/PriceSlider.vue';
import RadioButton from '@components/sidebar/BusinessTypeRadioButton.vue';

export default {
  components: {
    RadioButton,
    GenderSlider, PriceSlider, SizeSlider
  },
  props: {
    lang: {type: String, required: true, default: 'en' },
    debug: {type: Boolean, required: false, default: false},
    modelValue: {type: Object, required: true}
},
  data() {
    return {
      localModelValue: { ...this.modelValue },
      radioButtons: [
        {value: "beauty", label: { en: 'Beauty Salon', ja: '美容室' }, disabled: false},
        {value: "gym", label: { en: 'Gym', ja: 'ジム' }, disabled: false},
        {value: "conbini", label: { en: 'Conbini', ja: 'コンビニ' }, disabled: true},
        {value: "clinic", label: { en: 'Clinic', ja: 'クリニック' }, disabled: true},
        
        {value: "restaurant", label: { en: 'Restaurant', ja: '飲食' }, disabled: true},
        {value: "cafe", label: { en: 'Cafe', ja: 'カフェ' }, disabled: true},
        {value: "bar", label: { en: 'Bar', ja: 'バー' }, disabled: true},
        {value: "clothing", label: { en: 'Clothing Store', ja: '洋服' }, disabled: true},
        
        {value: "juku", label: { en: 'Cram School', ja: '学習塾' }, disabled: true},
        {value: "parking", label: { en: 'Parking', ja: '駐車場' }, disabled: true},
        {value: "gas_station", label: { en: 'Gas Station', ja: 'ガソスタ' }, disabled: true},
        {value: "cleaning", label: { en: 'Dry Cleaning', ja: 'クリーニング' }, disabled: true},
        
        {value: "laundromat", label: { en: 'Laundromat', ja: 'コインランドリー' }, disabled: true},
        {value: "hotel", label: { en: 'Hotel', ja: 'ホテル' }, disabled: true},
      ],

      // Below here is for touch controls
      isClosed: false,
      startY: 0,
      currentY: 0,
    };
  },
  methods: {
    getLangText,

    updateModelValue(event) {
      console.log("Sidebar updated to: "+event.target.value +" and emitted");
      this.$emit('update:modelValue', parseFloat(event.target.value));
    },

    /** Below this line is for the swipe */

    handleTouchStart(e) {
      console.log('Touch start');
      this.startY = e.touches[0].clientY;
      this.currentY = this.startY;
    },
    handleTouchMove(e) {
      console.log('Touch move');
      this.currentY = e.touches[0].clientY;
      const diffY = this.currentY - this.startY;

      if (diffY < 0 && !this.isClosed) {
        // Dragging up to close
        this.$el.style.transform = `translateY(${diffY}px)`;
      } else if (diffY > 0 && this.isClosed) {
        // Dragging down to open
        this.$el.style.transform = `translateY(calc(-100% + ${diffY}px))`;
      }
    },
    handleTouchEnd() {
      console.log('Touch end');
      const diffY = this.currentY - this.startY;

      if (diffY < -50 && !this.isClosed) {
        // Swipe up to close
        this.isClosed = true;
      } else if (diffY > 50 && this.isClosed) {
        // Swipe down to open
        this.isClosed = false;
      }

      // Reset transform
      this.$el.style.transform = '';
    },

    handleMouseDown(e) {
      console.log('Mouse down');
      this.startY = e.clientY;
      this.currentY = this.startY;
      document.addEventListener('mousemove', this.handleMouseMove);
      document.addEventListener('mouseup', this.handleMouseUp);
    },
    handleMouseMove(e) {
      console.log('Mouse move');
      this.currentY = e.clientY;
      const diffY = this.currentY - this.startY;

      if (diffY < 0 && !this.isClosed) {
        // Dragging up to close
        this.$el.style.transform = `translateY(${diffY}px)`;
      } else if (diffY > 0 && this.isClosed) {
        // Dragging down to open
        this.$el.style.transform = `translateY(calc(-100% + ${diffY}px))`;
      }
    },
    handleMouseUp() {
      console.log('Mouse up');
      const diffY = this.currentY - this.startY;

      if (diffY < -50 && !this.isClosed) {
        // Swipe up to close
        this.isClosed = true;
      } else if (diffY > 50 && this.isClosed) {
        // Swipe down to open
        this.isClosed = false;
      }

      // Reset transform
      this.$el.style.transform = '';
      document.removeEventListener('mousemove', this.handleMouseMove);
      document.removeEventListener('mouseup', this.handleMouseUp);
    },

  },
  watch: {
    modelValue: {
      handler(newValue) {
        if (JSON.stringify(newValue) !== JSON.stringify(this.localModelValue)) {
          this.localModelValue = { ...newValue };
        }
      },
      deep: true
    },

    localModelValue: {
      handler(newValue) {
        if (JSON.stringify(newValue) !== JSON.stringify(this.modelValue)) {
          
          this.$emit('update:modelValue', newValue);
          console.log("Sidebar updated to and emitted ",newValue);
        }
      },
      deep: true
    }
  }
};
</script>