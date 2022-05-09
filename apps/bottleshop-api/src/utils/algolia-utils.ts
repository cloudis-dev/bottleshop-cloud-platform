import 'firebase-functions';

import algoliasearch, {
  SearchClient,
  SearchIndex,
} from 'algoliasearch';

import { Product } from '../models/product';
import { productFields } from '../constants/model-constants';

const algoliaWarehouseIndex = 'dev_warehouse';
const algoliaCategoriesIndex = 'dev_categories';

const isSpecialEditionAlgoliaFieldName = 'is_special_edition';
export const objectIdAlgoliaFieldName = 'objectID';

export function createClient(algoliaConfig: { algoliaAdminKey: string }): SearchClient {
  return algoliasearch('HUD78UFQAW', algoliaConfig.algoliaAdminKey);
}

export function acquireProductsIndex(client: SearchClient): SearchIndex {
  return client.initIndex(algoliaWarehouseIndex);
}

export function acquireCategoriesIndex(client: SearchClient): SearchIndex {
  return client.initIndex(algoliaCategoriesIndex);
}

export function firebase2AlgoliaObjMappingFn(obj: Product): object {
  const algoliaObj = Object(obj);

  algoliaObj[productFields.countryRefField] = obj.country_ref.id;
  algoliaObj[productFields.unitRefField] = obj.unit_ref.id;
  algoliaObj[productFields.categoryRefsField] = obj.category_refs.map((val) => val.id);
  algoliaObj[isSpecialEditionAlgoliaFieldName] = (obj[productFields.editionField] ?? '').trim().length !== 0;
  algoliaObj[objectIdAlgoliaFieldName] = obj.cmat;

  return algoliaObj;
}
