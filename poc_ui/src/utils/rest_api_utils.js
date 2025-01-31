export function createApiUrlForListings(params) {
  const baseUrl = 'https://gold-rush-14804388067.asia-northeast1.run.app/listings';
  const queryParams = new URLSearchParams(params).toString();
  return `${baseUrl}?${queryParams}`;
}

export function createApiUrlForAddress(params) {
  const baseUrl = 'https://gold-rush-14804388067.asia-northeast1.run.app/address';
  const queryParams = new URLSearchParams(params).toString();
  return `${baseUrl}?${queryParams}`;
}

export function createApiUrlForListingDetail(params) {
  const baseUrl = 'https://gold-rush-14804388067.asia-northeast1.run.app/listing';
  const queryParams = new URLSearchParams(params).toString();
  return `${baseUrl}?${queryParams}`;
}

export async function callRestApi(apiURL){    
    try{
      //console.log("Fetching from API: "+ this.apiUrl);

      const response = await fetch(apiURL);
      if(! response.ok) throw new Error('Network Response was not ok', response);
      const data = await response.json();

      return data;
    } catch(error) {
      console.error('Error fetching from the API: ', error);
    }
}