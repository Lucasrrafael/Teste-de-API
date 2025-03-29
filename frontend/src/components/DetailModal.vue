<template>
  <div class="modal-overlay" @click="close">
    <div class="modal-content" @click.stop>
      <div class="modal-header">
        <h2>Detalhes do Resultado</h2>
        <button class="close-button" @click="close">&times;</button>
      </div>
      <div class="modal-body">
        <div v-for="field in columnOrder" :key="field" class="detail-row">
          <div class="detail-label">{{ field }}</div>
          <div class="detail-value">{{ formatValue(result[field]) }}</div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'DetailModal',
  props: {
    result: {
      type: Object,
      required: true
    },
    columnOrder: {
      type: Array,
      required: true
    }
  },
  methods: {
    formatValue(value) {
      if (value === null || value === undefined) return '-';
      if (typeof value === 'number') {
        return value.toLocaleString('pt-BR');
      }
      return value;
    },
    close() {
      this.$emit('close');
    }
  }
};
</script>

<style scoped>
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
}

.modal-content {
  background: white;
  border-radius: 8px;
  width: 90%;
  max-width: 800px;
  max-height: 90vh;
  overflow-y: auto;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.modal-header {
  padding: 1rem;
  border-bottom: 1px solid var(--border-color);
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.modal-header h2 {
  margin: 0;
  color: var(--text-color);
  font-size: 1.5rem;
}

.close-button {
  background: none;
  border: none;
  font-size: 1.5rem;
  cursor: pointer;
  color: var(--text-color);
  padding: 0.5rem;
  line-height: 1;
}

.modal-body {
  padding: 1rem;
}

.detail-row {
  display: flex;
  padding: 0.75rem;
  border-bottom: 1px solid var(--border-color);
}

.detail-row:last-child {
  border-bottom: none;
}

.detail-label {
  font-weight: 600;
  width: 200px;
  color: var(--text-color);
}

.detail-value {
  flex: 1;
  color: var(--text-color);
}
</style> 