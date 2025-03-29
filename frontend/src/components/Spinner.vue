<template>
  <div class="spinner">
    <div class="spinner-inner"></div>
  </div>
</template>

<script>
export default {
  name: 'LoadingSpinner'
}
</script>

<style scoped>
.spinner {
  display: inline-block;
  position: relative;
  width: 40px;
  height: 40px;
}

.spinner-inner {
  box-sizing: border-box;
  display: block;
  position: absolute;
  width: 32px;
  height: 32px;
  margin: 4px;
  border: 4px solid var(--primary-color);
  border-radius: 50%;
  animation: spinner 1.2s cubic-bezier(0.5, 0, 0.5, 1) infinite;
  border-color: var(--primary-color) transparent transparent transparent;
}

@keyframes spinner {
  0% {
    transform: rotate(0deg);
  }
  100% {
    transform: rotate(360deg);
  }
}
</style> 