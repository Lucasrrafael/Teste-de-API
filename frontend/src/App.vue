<template>
  <div class="container">
    <h1>Pesquisa no Relatório CADOP</h1>
    <SearchForm @search="performSearch" @advancedSearch="performAdvancedSearch" :fields="fields" />
    
    <div v-if="loading" class="loading">
      <LoadingSpinner />
      <p class="mt-2">Pesquisando...</p>
    </div>
    
    <div v-if="error" class="alert alert-error">
      {{ error }}
    </div>
    
    <div v-if="showResults && resultCount > 0" class="alert alert-tip">
      <TipIcon class="tip-icon" /> Dica: Clique nos resultados da busca para ver mais detalhes.
    </div>
    
    <div v-if="showResults && resultCount > 0" class="alert alert-info">
      Encontrados {{ resultCount }} resultados
    </div>

    <div v-if="showResults && resultCount === 0" class="alert alert-warning">
      Nenhum resultado encontrado.
    </div>
    
    <SearchResults :results="results" :columnOrder="fields" />
  </div>
</template>

<script>
import axios from 'axios';
import SearchForm from './components/SearchForm.vue';
import SearchResults from './components/SearchResults.vue';
import LoadingSpinner from './components/Spinner.vue';
import TipIcon from './components/icons/TipIcon.vue';

export default {
  name: 'App',
  components: {
    SearchForm,
    SearchResults,
    LoadingSpinner,
    TipIcon
  },
  data() {
    return {
      results: [],
      resultCount: 0,
      fields: [],
      loading: false,
      showResults: false,
      error: null
    };
  },
  mounted() {
    this.loadFields();
  },
  methods: {
    async loadFields() {
      try {
        const response = await axios.get('/api/campos');
        this.fields = response.data.campos;
        this.error = null;
      } catch (error) {
        console.error('Erro ao carregar campos:', error);
        this.error = 'Erro ao carregar campos. Por favor, tente novamente.';
      }
    },
    async performSearch(query) {
      this.loading = true;
      this.showResults = false;
      this.error = null;
      
      try {
        console.log('Iniciando pesquisa simples:', query);
        const response = await axios.get(`/api/pesquisa?consulta=${encodeURIComponent(query)}`);
        console.log('Resposta da pesquisa:', response.data);
        this.results = response.data.resultados;
        this.resultCount = response.data.contagem;
        this.showResults = true;
      } catch (error) {
        console.error('Erro detalhado na pesquisa:', error.response || error);
        this.error = error.response?.data?.erro || 'Erro ao realizar pesquisa. Por favor, verifique sua consulta e tente novamente.';
      } finally {
        this.loading = false;
      }
    },
    async performAdvancedSearch(field, query) {
      this.loading = true;
      this.showResults = false;
      this.error = null;
      
      try {
        console.log('Iniciando pesquisa avançada:', { field, query });
        const response = await axios.get(`/api/pesquisa/avancada?campo=${encodeURIComponent(field)}&consulta=${encodeURIComponent(query)}`);
        console.log('Resposta da pesquisa avançada:', response.data);
        this.results = response.data.resultados;
        this.resultCount = response.data.contagem;
        this.showResults = true;
      } catch (error) {
        console.error('Erro detalhado na pesquisa avançada:', error.response || error);
        this.error = error.response?.data?.erro || 'Erro ao realizar pesquisa avançada. Por favor, verifique os campos e tente novamente.';
      } finally {
        this.loading = false;
      }
    }
  }
};
</script>

<style scoped>
.loading {
  display: flex;
  flex-direction: column;
  align-items: center;
  margin: 2rem 0;
}
</style> 