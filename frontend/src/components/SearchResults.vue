<template>
  <div class="search-results">
    <div class="results-table">
      <table>
        <thead>
          <tr>
            <th v-for="field in visibleColumns" :key="field">{{ field }}</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(result, index) in results" :key="index" @click="showDetails(result)">
            <td v-for="field in visibleColumns" :key="field">
              {{ formatValue(result[field]) }}
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <DetailModal
      v-if="selectedResult"
      :result="selectedResult"
      :columnOrder="columnOrder"
      @close="closeDetails"
    />
  </div>
</template>

<script>
import DetailModal from './DetailModal.vue';

export default {
  name: 'SearchResults',
  components: {
    DetailModal
  },
  props: {
    results: {
      type: Array,
      required: true
    },
    columnOrder: {
      type: Array,
      required: true
    }
  },
  data() {
    return {
      selectedResult: null
    };
  },
  computed: {
    visibleColumns() {
      return this.columnOrder.slice(0, 5);
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
    showDetails(result) {
      this.selectedResult = result;
    },
    closeDetails() {
      this.selectedResult = null;
    }
  }
};
</script>

<style scoped>
.search-results {
  margin-top: 2rem;
  overflow-x: auto;
}

.results-table {
  background: white;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  overflow: hidden;
}

table {
  width: 100%;
  border-collapse: collapse;
  font-size: 0.9rem;
}

th, td {
  padding: 1rem;
  text-align: left;
  border-bottom: 1px solid var(--border-color);
}

th {
  background-color: var(--background-color);
  font-weight: 600;
  color: var(--text-color);
}

tr {
  cursor: pointer;
  transition: background-color 0.2s;
}

tr:hover {
  background-color: var(--hover-color);
}

td {
  color: var(--text-color);
}
</style> 