<template>
  <div class="edit-article--container">
    <resizable-text-area
      v-model="articleTitle"
      type="text"
      rows="1"
      class="article-heading"
      :placeholder="$t('HELP_CENTER.EDIT_ARTICLE.TITLE_PLACEHOLDER')"
      @focus="onFocus"
      @blur="onBlur"
      @input="onTitleInput"
    />
    <woot-article-editor
      v-model="articleContent"
      class="article-content"
      :placeholder="$t('HELP_CENTER.EDIT_ARTICLE.CONTENT_PLACEHOLDER')"
      @focus="onFocus"
      @blur="onBlur"
      @input="onContentInput"
    />
    <label
      class="article-questions"
      >
      {{ $t('HELP_CENTER.ARTICLE_EDITOR.QUESTIONS.LIST_QUESTION.LABEL')}}
      <div class="article-questions-list"
        v-for="item in articleQuestions"
        :key="item.id">
          <div class="article-question-flex-wrapper">
            <p>{{ item.content }}</p>
          </div>
      </div>
    </label>
    <label>
      {{ $t('HELP_CENTER.ARTICLE_EDITOR.QUESTIONS.ADD_QUESTION.LABEL') }}
      <textarea
      v-model="tmpQuestion"
      rows="2"
      type="text"
      :placeholder="
        $t('HELP_CENTER.ARTICLE_EDITOR.QUESTIONS.ADD_QUESTION.PLACEHOLDER')
      "
      />
      <woot-submit-button
        class="button nice success"
        :button-text="$t('HELP_CENTER.ARTICLE_EDITOR.QUESTIONS.BUTTON_ADD_QUESTION.TEXT')"
        @click="onAddQuestion"
      />
    </label>
    <div></div>
  </div>
</template>

<script>
import { debounce } from '@chatwoot/utils';
import ResizableTextArea from 'shared/components/ResizableTextArea';
import WootArticleEditor from 'dashboard/components/widgets/WootWriter/FullEditor.vue';

export default {
  components: {
    WootArticleEditor,
    ResizableTextArea,
  },
  props: {
    article: {
      type: Object,
      default: () => ({}),
    },
    isSettingsSidebarOpen: {
      type: Boolean,
      default: false,
    }
  },
  data() {
    return {
      articleTitle: '',
      articleContent: '',
      tmpQuestion: '',
      articleQuestions: [],
      saveArticle: () => {},
    };
  },
  mounted() {
    this.articleTitle = this.article.title;
    this.articleContent = this.article.content;
    this.articleQuestions = this.article.questions;
    this.tmpQuestion = '';
    this.saveArticle = debounce(
      values => {
        this.$emit('save-article', values);
      },
      300,
      false
    );
  },
  methods: {
    onFocus() {
      this.$emit('focus');
    },
    onBlur() {
      this.$emit('blur');
    },
    onTitleInput() {
      this.saveArticle({ title: this.articleTitle });
    },
    onContentInput() {
      this.saveArticle({ content: this.articleContent });
    },
    onAddQuestion() {
      this.saveArticle({ article: {questions: [{content: this.tmpQuestion }]}});
      this.tmpQuestion = '';
      this.articleQuestions = this.article.questions;
    },
    onClickDeleteQuestion(id){
      console.log(id);
    }
  },
};
</script>

<style lang="scss" scoped>
.edit-article--container {
  margin: var(--space-large) auto;
  padding: 0 var(--space-medium);
  max-width: 89.6rem;
  width: 100%;
}

.article-heading {
  font-size: var(--font-size-giga);
  font-weight: var(--font-weight-bold);
  width: 100%;
  min-height: var(--space-jumbo);
  max-height: 64rem;
  height: auto;
  margin-bottom: var(--space-small);
  border: 0px solid transparent;
  padding: 0;
  color: var(--s-900);
  padding: var(--space-normal);
  resize: none;

  &:hover {
    background: var(--s-25);
    border-radius: var(--border-radius-normal);
  }
}


.article-questions-list {
  margin-top: 2px;
  margin-bottom: 2px;
  border-bottom: 1px solid var(--s-200);
}

.article-questions-list p {
  font-weight: var(--font-weight-medium);
  padding-top: 4px;
  margin: 0;
}

.article-question-flex-wrapper{
  display: flex;
  justify-content: space-between;
}

.article-content {
  padding: 0 var(--space-normal);
  height: fit-content;
}

::v-deep {
  .ProseMirror-menubar-wrapper {
    .ProseMirror-woot-style {
      min-height: var(--space-giga);
      max-height: 100%;
    }
  }
}
</style>
