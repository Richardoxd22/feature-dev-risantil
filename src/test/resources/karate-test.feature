@REQ_feature/dev-risantil @HUfeature/dev-risantil @marvel_characters_crud @marvel_characters_api @Agente2 @E2 @iniciativa_marvel
Feature: feature/dev-risantil CRUD de personajes Marvel (microservicio para gestión de personajes)
  Background:
    * url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/risantil/api/characters'
    * def generarHeaders =
      """
      function() {
        return {
          "Content-Type": "application/json"
        };
      }
      """
    * def headers = generarHeaders()
    * headers headers

  @id:1 @getAllCharacters @solicitudExitosa200
  Scenario: T-API-feature/dev-risantil-CA01-Obtener todos los personajes 200 - karate
    When method GET
    Then status 200
    # And match response == []

  @id:2 @getCharacterById @solicitudExitosa200
  Scenario: T-API-feature/dev-risantil-CA02-Obtener personaje por ID exitoso 200 - karate
    * def jsonData = read('classpath:data/marvel_characters_api/character_create.json')
    * set jsonData.name = jsonData.name + ' ' + java.util.UUID.randomUUID()
    And request jsonData
    When method POST
    Then status 201
    * def characterId = response.id
    Given path characterId
    When method GET
    Then status 200
    # And match response.id == characterId
    # And match response.name == 'Iron Man'

  @id:3 @getCharacterById @noEncontrado404
  Scenario: T-API-feature/dev-risantil-CA03-Obtener personaje por ID no existe 404 - karate
    Given path '999'
    When method GET
    Then status 404
    # And match response.error contains 'not found'

  @id:4 @createCharacter @creacionExitosa201
  Scenario: T-API-feature/dev-risantil-CA04-Crear personaje exitosamente 201 - karate
    # Verificar que el endpoint está disponible antes de continuar
    Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/risantil/api/characters'
    When method GET
    Then status 200
    * def jsonData = read('classpath:data/marvel_characters_api/character_create.json')
    * set jsonData.name = 'Iron Man ' + java.util.UUID.randomUUID()
    And request jsonData
    When method POST
    Then status 201
  # And match response.name contains 'Iron Man'
  # And match response.id != null

  @id:5 @createCharacter @nombreDuplicado400
  Scenario: T-API-feature/dev-risantil-CA05-Crear personaje con nombre duplicado 400 - karate
    * def jsonData = read('classpath:data/marvel_characters_api/character_duplicate.json')
    And request jsonData
    When method POST
    Then status 400
    # And match response.error contains 'already exists'

  @id:6 @createCharacter @faltanCampos400
  Scenario: T-API-feature/dev-risantil-CA06-Crear personaje con campos requeridos faltantes 400 - karate
    * def jsonData = read('classpath:data/marvel_characters_api/character_invalid.json')
    And request jsonData
    When method POST
    Then status 400
    # And match response.name contains 'required'

  @id:7 @updateCharacter @actualizacionExitosa200
  Scenario: T-API-feature/dev-risantil-CA07-Actualizar personaje exitosamente 200 - karate
    * def jsonData = read('classpath:data/marvel_characters_api/character_create.json')
    * set jsonData.name = jsonData.name + ' ' + java.util.UUID.randomUUID()
    And request jsonData
    When method POST
    Then status 201
    * def characterId = response.id
    Given path characterId
    * def updateData = read('classpath:data/marvel_characters_api/character_update.json')
    And request updateData
    When method PUT
    Then status 200
    # And match response.description == 'Updated description'

  @id:8 @updateCharacter @noEncontrado404
  Scenario: T-API-feature/dev-risantil-CA08-Actualizar personaje no existe 404 - karate
    Given path '999'
    * def jsonData = read('classpath:data/marvel_characters_api/character_update.json')
    And request jsonData
    When method PUT
    Then status 404
    # And match response.error contains 'not found'

  @id:9 @deleteCharacter @eliminacionExitosa204
  Scenario: T-API-feature/dev-risantil-CA09-Eliminar personaje exitosamente 204 - karate
    * def jsonData = read('classpath:data/marvel_characters_api/character_create.json')
    * set jsonData.name = jsonData.name + ' ' + java.util.UUID.randomUUID()
    And request jsonData
    When method POST
    Then status 201
    * def characterId = response.id
    Given path characterId
    When method DELETE
    Then status 204

  @id:10 @deleteCharacter @noEncontrado404
  Scenario: T-API-feature/dev-risantil-CA10-Eliminar personaje no existe 404 - karate
    Given path '999'
    When method DELETE
    Then status 404
    # And match response.error contains 'not found'
