<template>
  <div class="container overflow-auto">
    <article-header
      :header-title="headerTitle"
      :count="meta.count"
      selected-value="Published"
      @newArticlePage="newArticlePage"
      @visible-search-form="toggleVisibleSearchForm"
      @open-load-config-form="openVisibleLoadingConfigForm"
    />
    <Modal
        :show="showModalLoadingFile"
        :on-close="closeVisibleLoadingConfigForm"
    >
      <form-load-config
          :is-loading="loadingConfigFile"
          @submit="loadConfigArticlesFile"
      />
    </Modal>
    <div
        v-if="isSearchFormVisible"
        class="article-list-search-container">
      <form-search
          :is-loading-search="isLoadingSearch"
          @submit="searchFormArticles"
      ></form-search>
    </div>
    <article-table
      :articles="articles"
      :current-page="Number(meta.currentPage)"
      :total-count="Number(meta.count)"
      :buttons-sort="buttonsSort"
      @page-change="onPageChange"
      @reorder="onReorder"
      @sort-articles="sortArticle"
    />
    <div v-if="shouldShowLoader" class="articles--loader">
      <spinner />
      <span>{{ $t('HELP_CENTER.TABLE.LOADING_MESSAGE') }}</span>
    </div>
    <empty-state
      v-else-if="shouldShowEmptyState"
      :title="$t('HELP_CENTER.TABLE.NO_ARTICLES')"
    />
  </div>
</template>
<script>
import { mapGetters } from 'vuex';

import Spinner from 'shared/components/Spinner.vue';
import ArticleHeader from 'dashboard/routes/dashboard/helpcenter/components/Header/ArticleHeader';
import EmptyState from 'dashboard/components/widgets/EmptyState';
import ArticleTable from '../../components/ArticleTable';
import FormSearch from "../../components/FormSearch";
import Modal from "../../../../../components/Modal";
import FormLoadConfig from "../../components/FormLoadConfig";

export default {
  components: {
    ArticleHeader,
    ArticleTable,
    EmptyState,
    Spinner,
    FormSearch,
    Modal,
    FormLoadConfig,
  },
  data() {
    return {
      pageNumber: 1,
      isSearchFormVisible: false,
      isLoadingSearch: false,
      titleSearch: '',
      textSearch: '',
      buttonsSort: {
        titleSortActive: false,
        categorySortActive: false,
        lastEditedSortActive: false,
      },
      loadingConfigFile: false,
      showModalLoadingFile: false,
    };
  },
  computed: {
    ...mapGetters({
      articles: 'articles/allArticles',
      categories: 'categories/allCategories',
      uiFlags: 'articles/uiFlags',
      meta: 'articles/getMeta',
      isFetching: 'articles/isFetching',
      currentUserId: 'getCurrentUserID',
    }),
    selectedCategory() {
      return this.categories.find(
        category => category.slug === this.selectedCategorySlug
      );
    },
    shouldShowEmptyState() {
      return !this.isFetching && !this.articles.length;
    },
    shouldShowLoader() {
      return this.isFetching && !this.articles.length;
    },
    selectedPortalSlug() {
      return this.$route.params.portalSlug;
    },
    selectedCategorySlug() {
      const { categorySlug } = this.$route.params;
      return categorySlug;
    },
    articleType() {
      return this.$route.path.split('/').pop();
    },
    headerTitle() {
      switch (this.articleType) {
        case 'mine':
          return this.$t('HELP_CENTER.HEADER.TITLES.MINE');
        case 'draft':
          return this.$t('HELP_CENTER.HEADER.TITLES.DRAFT');
        case 'archived':
          return this.$t('HELP_CENTER.HEADER.TITLES.ARCHIVED');
        default:
          if (this.$route.name === 'show_category') {
            return this.headerTitleInCategoryView;
          }
          return this.$t('HELP_CENTER.HEADER.TITLES.ALL_ARTICLES');
      }
    },
    status() {
      switch (this.articleType) {
        case 'draft':
          return 0;
        case 'published':
          return 1;
        case 'archived':
          return 2;
        default:
          return undefined;
      }
    },
    author() {
      if (this.articleType === 'mine') {
        return this.currentUserId;
      }
      return null;
    },
    headerTitleInCategoryView() {
      return this.categories && this.categories.length
        ? this.selectedCategory.name
        : '';
    },
  },
  watch: {
    $route() {
      this.pageNumber = 1;
      this.fetchArticles();
    },
  },
  mounted() {
    this.fetchArticles();
  },

  methods: {
    loadConfigArticlesFile(file) {
      const formData = new FormData();
      this.loadingConfigFile = true;
      this.$store.dispatch('articles/loadConfigFile', {
        portalSlug: this.$route.params.portalSlug,
        file: file
      });
      this.loadingConfigFile = false;
    },
    openVisibleLoadingConfigForm() {
      this.showModalLoadingFile = true;
    },
    closeVisibleLoadingConfigForm() {
      this.showModalLoadingFile = false;
    },
    resetAllSortButtons() {
      this.buttonsSort.titleSortActive = false;
      this.buttonsSort.categorySortActive = false;
      this.buttonsSort.lastEditedSortActive = false;
    },
    sortArticle(sortValue) {
      const localSortValue = sortValue.replace(/-/, '');
      if (localSortValue === 'title') {
        this.buttonsSort.titleSortActive = true;
        this.buttonsSort.categorySortActive = false;
        this.buttonsSort.lastEditedSortActive = false;
      } else if (localSortValue === 'category') {
        this.buttonsSort.titleSortActive = false;
        this.buttonsSort.categorySortActive = true;
        this.buttonsSort.lastEditedSortActive = false;
      } else if (localSortValue === 'updated_at') {
        this.buttonsSort.titleSortActive = false;
        this.buttonsSort.categorySortActive = false;
        this.buttonsSort.lastEditedSortActive = true;
      }
      this.fetchArticles({sort: sortValue, titleSearch: this.titleSearch, textSearch: this.textSearch});
    },
    toggleVisibleSearchForm(data) {
      this.isSearchFormVisible = data;
    },
    searchFormArticles({ title, text }) {
      this.isLoadingSearch = true;
      this.titleSearch = title;
      this.textSearch = text;
      this.resetAllSortButtons();
      this.fetchArticles({pageNumber: 1, titleSearch: this.titleSearch, textSearch: this.textSearch});
    },
    newArticlePage() {
      this.$router.push({ name: 'new_article' });
    },
    fetchArticles({ pageNumber, titleSearch, textSearch, sort = null } = {}) {
      this.$store.dispatch('articles/index', {
        pageNumber: pageNumber || this.pageNumber,
        portalSlug: this.$route.params.portalSlug,
        locale: this.$route.params.locale,
        status: this.status,
        author_id: this.author,
        category_slug: this.selectedCategorySlug,
        titleSearch,
        textSearch,
        sort,
      });
      this.isLoadingSearch = false;
    },
    onPageChange(pageNumber) {
      this.fetchArticles({ pageNumber });
    },
    onReorder(reorderedGroup) {
      this.$store.dispatch('articles/reorder', {
        reorderedGroup,
        portalSlug: this.$route.params.portalSlug,
      });
    },
  },
};
</script>

<style lang="scss" scoped>
.container {
  padding: 0 var(--space-normal);
  width: 100%;
  overflow: auto;
  .articles--loader {
    align-items: center;
    display: flex;
    font-size: var(--font-size-default);
    justify-content: center;
    padding: var(--space-big);
  }
}
</style>
