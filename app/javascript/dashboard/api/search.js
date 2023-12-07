/* global axios */
import ApiClient from './ApiClient';

class SearchAPI extends ApiClient {
  constructor() {
    super('search', { accountScoped: true });
  }

  get({ q }) {
    return axios.get(this.url, {
      params: {
        q,
      },
    });
  }

  contacts({ q, offset }) {
    return axios.get(`${this.url}/contacts`, {
      params: {
        q,
        offset
      },
    });
  }

  conversations({ q, offset }) {
    return axios.get(`${this.url}/conversations`, {
      params: {
        q,
        offset
      },
    });
  }

  messages({ q, offset }) {
    return axios.get(`${this.url}/messages`, {
      params: {
        q,
        offset
      },
    });
  }
}

export default new SearchAPI();
