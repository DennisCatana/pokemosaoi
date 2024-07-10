class CatService {
  Future<List<String>> fetchCatImages({int width = 100, int height = 100}) async {
    List<String> imageUrls = [];

    // Agrega dos URLs únicas para obtener imágenes de gatos con ancho o altura específica
    imageUrls.add('https://cataas.com/cat?width=$width');
    imageUrls.add('https://cataas.com/cat?height=$height');

    return imageUrls;
  }
}

