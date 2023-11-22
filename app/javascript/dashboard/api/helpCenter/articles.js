/* global axios */

import PortalsAPI from './portals';

class ArticlesAPI extends PortalsAPI {
  constructor() {
    super('articles', { accountScoped: true });
  }

  getArticles({
    pageNumber,
    portalSlug,
    locale,
    status,
    author_id,
    category_slug,
    titleSearch,
    textSearch,
    sort,
  }) {
    let baseUrl = `${this.url}/${portalSlug}/articles?page=${pageNumber}&locale=${locale}`;
    if (status !== undefined) baseUrl += `&status=${status}`;
    if (author_id) baseUrl += `&author_id=${author_id}`;
    if (category_slug) baseUrl += `&category_slug=${category_slug}`;

    if (titleSearch && textSearch) {
      baseUrl += `&title=${titleSearch}&content=${textSearch}`;
    } else if (titleSearch) {
      baseUrl += `&title=${titleSearch}`;
    } else if (textSearch) {
      baseUrl += `&content=${textSearch}`;
    }
    if (sort) baseUrl += `&sort=${sort}`;
    return axios.get(baseUrl);
  }

  getArticle({ id, portalSlug }) {
    return axios.get(`${this.url}/${portalSlug}/articles/${id}`);
  }

  updateArticle({ portalSlug, articleId, articleObj }) {
    return axios.patch(
      `${this.url}/${portalSlug}/articles/${articleId}`,
      articleObj
    );
  }

  createArticle({ portalSlug, articleObj }) {
    const { content, title, author_id, category_id, questions } = articleObj;
    return axios.post(`${this.url}/${portalSlug}/articles`, {
      content,
      title,
      author_id,
      category_id,
      questions,
    });
  }

  deleteArticle({ articleId, portalSlug }) {
    return axios.delete(`${this.url}/${portalSlug}/articles/${articleId}`);
  }

  uploadImage({ portalSlug, file }) {
    let formData = new FormData();
    formData.append('background_image', file);
    return axios.post(
      `${this.url}/${portalSlug}/articles/attach_file`,
      formData,
      {
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      }
    );
  }

  reorderArticles({ portalSlug, reorderedGroup, categorySlug }) {
    return axios.post(`${this.url}/${portalSlug}/articles/reorder`, {
      positions_hash: reorderedGroup,
      category_slug: categorySlug,
    });
  }

  deleteQuestion({ articleId, portalSlug, questionId }) {
    return axios.delete(`${this.url}/${portalSlug}/articles/${articleId}/questions/${questionId}`);
  }

  getQuestions({ articleId, portalSlug }) {
    return axios.get(`${this.url}/${portalSlug}/articles/${articleId}/questions`);
  }

  addQuestion({ articleId, portalSlug, content}) {
    return axios.post(`${this.url}/${portalSlug}/articles/${articleId}/questions`, {
      content: content
    });
  }

  loadConfigFile({ account_id, portalSlug, formData}) {
    return axios.post(`/api/v1/accounts/${account_id}/portals/${portalSlug}/articles/import `, {
      data: formData
    });
  }
}

export default new ArticlesAPI();
