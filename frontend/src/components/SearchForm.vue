<template>
  <div class="search-card">
    <div class="search-section mb-3">
      <h3>Pesquisa Simples</h3>
      <div class="search-row">
        <div class="search-input">
          <input 
            type="text" 
            v-model="searchQuery" 
            class="form-control" 
            placeholder="Digite sua pesquisa aqui..." 
            @keyup.enter="handleSearch"
          >
        </div>
        <div class="search-button">
          <button @click="handleSearch" class="btn btn-primary">
            <SearchIcon class="icon" />
            Pesquisar
          </button>
        </div>
      </div>
    </div>
    
    <div class="search-section">
      <h3>Pesquisa Avançada</h3>
      <div class="search-row">
        <div class="search-field">
          <select v-model="selectedField" class="form-select">
            <option value="">Selecione um campo</option>
            <option v-for="field in fields" :key="field" :value="field">{{ field }}</option>
          </select>
        </div>
        <div class="search-input">
          <input 
            type="text" 
            v-model="advancedQuery" 
            class="form-control" 
            placeholder="Digite sua pesquisa avançada aqui..." 
            @keyup.enter="handleAdvancedSearch"
          >
        </div>
        <div class="search-button">
          <button @click="handleAdvancedSearch" class="btn btn-secondary">
            <FilterIcon class="icon" />
            Pesquisar
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import SearchIcon from './icons/SearchIcon.vue';
import FilterIcon from './icons/FilterIcon.vue';

export default {
  name: 'SearchForm',
  components: {
    SearchIcon,
    FilterIcon
  },
  props: {
    fields: {
      type: Array,
      default: () => []
    }
  },
  data() {
    return {
      searchQuery: '',
      advancedQuery: '',
      selectedField: '',
      showAdvancedSearch: false
    };
  },
  methods: {
    handleSearch() {
      const query = this.searchQuery.trim();
      if (!query) {
        alert('Por favor, digite um termo para pesquisa');
        return;
      }
      console.log('Enviando pesquisa simples:', query);
      this.$emit('search', query);
    },
    handleAdvancedSearch() {
      const query = this.advancedQuery.trim();
      if (!this.selectedField) {
        alert('Por favor, selecione um campo para pesquisa');
        return;
      }
      if (!query) {
        alert('Por favor, digite um termo para pesquisa');
        return;
      }
      console.log('Enviando pesquisa avançada:', { field: this.selectedField, query });
      this.$emit('advancedSearch', this.selectedField, query);
    },
    toggleAdvancedSearch() {
      this.showAdvancedSearch = !this.showAdvancedSearch;
    }
  }
};
</script>

<style scoped>
.search-card {
  background-color: white;
  border-radius: 8px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
  padding: 24px;
  margin-bottom: 24px;
}

.search-section h3 {
  font-size: 1.2rem;
  margin-bottom: 16px;
  color: var(--primary-color);
}

.search-row {
  display: flex;
  flex-wrap: wrap;
  gap: 16px;
  align-items: flex-end;
}

.search-input {
  flex: 2;
  min-width: 200px;
}

.search-field {
  flex: 1;
  min-width: 180px;
}

.search-button {
  flex: 1;
  min-width: 180px;
}

.btn {
  width: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
}

.icon {
  width: 16px;
  height: 16px;
}

@media (max-width: 768px) {
  .search-row {
    flex-direction: column;
  }
  
  .search-input, .search-field, .search-button {
    width: 100%;
    flex: none;
  }
}
</style> 