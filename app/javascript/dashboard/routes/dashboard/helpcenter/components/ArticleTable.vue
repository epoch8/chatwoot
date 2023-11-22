<template>
  <div class="article-container">
    <div
      class="article-container--header"
      :class="{ draggable: onCategoryPage }"
    >
      <div class="heading-item heading-title">
        <button-sort-articles
            :active="buttonsSort.titleSortActive"
            :disabled="isFetching"
            @click="sortArticles($event, 'title')"
        >
          <p>
            {{ $t('HELP_CENTER.TABLE.HEADERS.TITLE') }}
          </p>
        </button-sort-articles>
      </div>
      <div class="heading-item heading-category">
        <button-sort-articles
            :active="buttonsSort.categorySortActive"
            :disabled="isFetching"
            @click="sortArticles($event, 'category')"
        >
          <p>
            {{ $t('HELP_CENTER.TABLE.HEADERS.CATEGORY') }}
          </p>
        </button-sort-articles>
      </div>
      <div class="heading-item heading-read-count">
        <p>
          {{ $t('HELP_CENTER.TABLE.HEADERS.READ_COUNT') }}
        </p>
      </div>
      <div class="heading-item heading-status">
        <p>
          {{ $t('HELP_CENTER.TABLE.HEADERS.STATUS') }}
        </p>
      </div>
      <div class="heading-item heading-last-edited">
        <button-sort-articles
            :active="buttonsSort.lastEditedSortActive"
            :disabled="isFetching"
            @click="sortArticles($event, 'updated_at')"
        >
          <p>
            {{ $t('HELP_CENTER.TABLE.HEADERS.LAST_EDITED') }}
          </p>
        </button-sort-articles>
      </div>
    </div>
    <draggable
      tag="div"
      class="article-container--border"
      :disabled="!dragEnabled"
      :list="localArticles"
      ghost-class="article-ghost-class"
      @start="dragging = true"
      @end="onDragEnd"
    >
      <ArticleItem
        v-for="article in localArticles"
        :id="article.id"
        :key="article.id"
        :class="{ draggable: onCategoryPage }"
        :title="article.title"
        :author="article.author"
        :category="article.category"
        :views="article.views"
        :status="article.status"
        :updated-at="article.updated_at"
      />
    </draggable>

    <table-footer
      v-if="articles.length"
      :current-page="currentPage"
      :total-count="totalCount"
      :page-size="pageSize"
      @page-change="onPageChange"
    />
  </div>
</template>

<script>
import { mapGetters } from 'vuex';
import ArticleItem from './ArticleItem.vue';
import TableFooter from 'dashboard/components/widgets/TableFooter';
import draggable from 'vuedraggable';
import ButtonSortArticles from '../components/ButtonSortArticles';

export default {
  components: {
    ArticleItem,
    TableFooter,
    draggable,
    ButtonSortArticles,
  },
  props: {
    articles: {
      type: Array,
      default: () => {},
    },
    totalCount: {
      type: Number,
      default: 0,
    },
    currentPage: {
      type: Number,
      default: 1,
    },
    pageSize: {
      type: Number,
      default: 25,
    },
    buttonsSort: {
      type: Object,
      default: () => {},
    },
  },
  data() {
    return {
      localArticles: [],
    };
  },
  computed: {
    ...mapGetters({
      isFetching: 'articles/isFetching',
    }),
    dragEnabled() {
      // dragging allowed only on category page
      return (
        this.articles.length > 1 && !this.isFetching && this.onCategoryPage
      );
    },
    onCategoryPage() {
      return this.$route.name === 'show_category';
    },
  },
  mounted() {
    this.localArticles = [...this.articles];
  },
  watch: {
    articles() {
      this.localArticles = [...this.articles];
    },
  },
  methods: {
    sortArticles(sortingAsc, categorySort) {
      const emitValue = sortingAsc ? categorySort : `-${categorySort}`;
      this.$emit('sort-articles', emitValue);
    },
    onDragEnd() {
      // why reuse the same positons array, instead of creating a new one?
      // this ensures that the shuffling happens within the same group
      // itself and does not create any new positions and avoid conflict with existing articles
      // so if a user sorts on page number 2, and the positions are say [550, 560, 570, 580, 590]
      // the new sorted items will be in the same position range as well
      const sortedArticlePositions = this.localArticles
        .map(article => article.position)
        .sort((a, b) => {
          // Why sort like this? Glad you asked!
          // because JavaScript is the doom of my existence, and if a `compareFn` is not supplied,
          // all non-undefined array elements are sorted by converting them to strings
          // and comparing strings in UTF-16 code units order.
          //
          // so an array [20, 10000, 10, 30, 40] will be sorted as [10, 10000, 20, 30, 40]

          return a - b;
        });

      const orderedArticles = this.localArticles.map(article => article.id);

      const reorderedGroup = orderedArticles.reduce((obj, key, index) => {
        obj[key] = sortedArticlePositions[index];
        return obj;
      }, {});

      this.$emit('reorder', reorderedGroup);
    },
    onPageChange(page) {
      this.$emit('page-change', page);
    },
  },
};
</script>
<style lang="scss" scoped>
.article-container {
  width: 100%;

  & > :not([hidden]) ~ :not([hidden]) {
    border-top-width: 1px;
    border-bottom-width: 0px;
  }

  .article-container--header {
    margin: 0 var(--space-minus-normal);
    padding: 0 var(--space-normal);
    display: grid;
    gap: var(--space-normal);
    border-bottom: 1px solid var(--s-100);
    grid-template-columns: repeat(8, minmax(0, 1fr));

    @media (max-width: 1024px) {
      grid-template-columns: repeat(7, minmax(0, 1fr));
    }

    @media (max-width: 768px) {
      grid-template-columns: repeat(6, minmax(0, 1fr));
    }

    &.draggable {
      div.heading-item.heading-title {
        padding: var(--space-small) var(--space-snug);
      }
    }

    div.heading-item {
      font-weight: var(--font-weight-bold);
      text-transform: capitalize;
      color: var(--s-700);
      font-size: var(--font-size-small);
      text-align: right;
      padding: var(--space-small) 0;

      & p {
        margin-bottom: 0;
      }

      &.heading-title {
        text-align: left;
        grid-column: span 4 / span 4;
      }

      @media (max-width: 1024px) {
        &.heading-read-count {
          display: none;
        }
      }

      @media (max-width: 768px) {
        &.heading-read-count,
        &.heading-last-edited {
          display: none;
        }
      }
    }
  }

  .footer {
    padding: 0;
    border: 0;
  }
}

.article-ghost-class {
  opacity: 0.5;
  background-color: var(--s-50);
}
</style>
