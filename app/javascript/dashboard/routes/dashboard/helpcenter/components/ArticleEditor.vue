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
    <div
        v-if="isNewArticle"
        class="article-not-active"
    >
      {{ $t('HELP_CENTER.DISABLE_QUESTION') }}
    </div>
    <div v-else>
      <div class="article-questions">
        <h6>{{ $t('HELP_CENTER.ARTICLE_EDITOR.QUESTIONS.LIST_QUESTION.LABEL')}}</h6>
        <div class="article-questions-not-found" v-if="articleQuestions.length === 0">
          <p>{{ $t('HELP_CENTER.ARTICLE_EDITOR.QUESTIONS.LIST_QUESTION_IS_EMPTY.TEXT') }}</p>
        </div>
        <div class="article-questions-list"
             v-else>
          <div v-for="item in articleQuestions" :key="item.id" class="article-question-flex-wrapper">
            <p>{{ item.content }}</p>
            <woot-button
                class="button-delete"
                icon="delete"
                size="small"
                variant="clear"
                color-scheme="alert"
                @click="onClickDeleteQuestion(item.id)">
            </woot-button>
          </div>
        </div>
      </div>
      <label class="article-add-question">
        <h6>{{ $t('HELP_CENTER.ARTICLE_EDITOR.QUESTIONS.ADD_QUESTION.LABEL') }}</h6>
        <textarea
            v-model="tmpQuestion"
            rows="2"
            type="text"
            :placeholder="
        $t('HELP_CENTER.ARTICLE_EDITOR.QUESTIONS.ADD_QUESTION.PLACEHOLDER')
      "
        />
        <woot-submit-button
            class="button nice success button-submit-success"
            :button-text="$t('HELP_CENTER.ARTICLE_EDITOR.QUESTIONS.BUTTON_ADD_QUESTION.TEXT')"
            :disabled="questionsButtonDisable"
            @click="onAddQuestion"
        />
      </label>
    </div>
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
      saveQuestion: () => {},
      deleteQuestion: () => {},
    };
  },
  computed: {
    isNewArticle() {
      return this.article.status === 'new';
    },
    questionsButtonDisable() {
      return this.tmpQuestion.length === 0;
    },
  },
  mounted() {
    this.articleTitle = this.article.title;
    this.articleContent = this.article.content;
    this.articleQuestions = this.article.questions?.sort((a, b) => {
      return a.id - b.id
    });
    this.tmpQuestion = '';
    this.saveQuestion = (data) => {
      this.$emit('add-question', data);
    }
    this.deleteQuestion = (data) => {
      this.$emit('delete-question', data);
    }
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
      this.saveQuestion({ content: this.tmpQuestion })
      this.tmpQuestion = '';
    },
    onClickDeleteQuestion(id){
      this.deleteQuestion( {questionId: id} )
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

.article-questions h6{
  font-weight: var(--font-weight-bold);
}

.article-questions-list {
  margin-top: 12px;

}

.article-not-active {
  font-size: 16px;
  line-height: 1.2;
}

.article-question-flex-wrapper {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 2px;
  border-bottom: 1px solid var(--s-200);
}

.article-question-flex-wrapper p {
  padding-top: 4px;
}

.button-submit-success {
  float: right;
}

.button-delete {
  min-width: 32px;
  min-height: 32px;
}

.article-content {
  padding: 0 var(--space-normal);
  height: fit-content;
}

.article-add-question {
  margin-top: 16px;
  font-weight: var(--font-weight-bold);
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
