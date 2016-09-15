$(document).on 'ready page:load', ->
  $('#user_avatar').bind 'change', ->
    size = @files[0].size / 1024
    if size > 100
      alert 'Maximum file size is 100Kb'

  $('#searchWord').keyup ->
    value = $(this).val()
    $('ol li').each ->
      if $(this).text().search(value) > -1
        $(this).show()
      else
        $(this).hide()

  sortWords = ->
    values = []
    list = $('ol li')
    list.each ->
      values.push $(this).text()
    values.sort
    values.reverse()
    i = 0
    while i < list.length
      list[i].innerHTML = '<p>' + values[i] + '</p>'
      i++

  desc = true
  $('#desc').click ->
    if desc
      sortWords()
      desc = false
      $(this).attr 'checked', true
  $('#asc').click ->
    if !desc
      sortWords()
      desc = true

  $('#new_category').submit (e) ->
    e.preventDefault()
    action = $(this).attr('action')
    method = $(this).attr('method')
    data = $(this).serializeArray()
    $.ajax
      url: action
      method: method
      data: data
      dataType: 'json'
      success: (result) ->
        $('#newCategoryModal').modal('toggle');
        alert 'Create successful'
        $('#tableHeading').remove();
        $('#tableCategoriesResult').prepend(newCategory(result))
        $('#tableCategoriesResult').prepend(headingTableCategory)
      error: (result) ->
        alert 'Can\'t create category. Check information please'

  headingTableCategory = ->
    res = '<tr id="tableHeading"><th></th>'
    res += '<th class="text-center">Name</th>'
    res += '<th class="text-center">Description</th>'
    res += '<th class="text-center">Total words</th></tr>'
    res

  newCategory = (result) ->
    res = '<tr><td col-md-1><input name="category_ids[]"'
    res += 'id="category_ids_" value="'
    res += result.id
    res += '" type="checkbox"></td>'
    res += '<input name="id" id="id" value="' + result.id + '" type="hidden">'
    res += '<td class="col-md-2 text-center">'
    res += '<a href="/admin/categories/' + result.id + '/words">' 
    res += result.name + '</a>'
    res += '</td>'
    res += '<td class="col-md-3 text-center">' + result.description + '</td>'
    res += '<td class="col-md-5 text-center">' + result.numberWords + '</td>'
    res += '<td class="text-center"><a data-toggle="tooltip" title="Edit" '
    res += 'href="/admin/categories/'
    res += result.id + '">'
    res += '<i class="glyphicon glyphicon-pencil"></i></a></td>'
    res += '<td class="text-center"><a data-toggle="tooltip" title="Delete" '
    res += 'data-confirm="Are you sure?" rel="nofollow" data-method="delete" '
    res += 'href="/admin/categories/'
    res += result.id + '">'
    res += '<i class="glyphicon glyphicon-trash"></i></a></td></tr>'
    res

  $('#new_word').submit (e) ->
    e.preventDefault()
    action = $(this).attr('action')
    method = $(this).attr('method')
    data = $(this).serializeArray();
    $.ajax
      url: action
      method: method
      data: data
      dataType: 'json'
      success: (result) ->
        $('#newWordModal').modal('toggle');
        alert 'Create successful'
        $('#tableHeading').remove();
        $('#tableWordResult').prepend(newWord(result))
        $('#tableWordResult').prepend(headingTableWord)
      error: (result) ->
        alert 'Can\'t create word. Please check information and try again'

  headingTableWord = ->
    res = '<tr id="tableHeading"><th></th>'
    res += '<th class="text-center">ID</th>'
    res += '<th class="text-center">Word</th>'
    res += '<th class="text-center">Answer</th></tr>'
    res

  newWord = (result) ->
    res = '<tr><td><input name="word_ids[]" id="word_ids_" value="' + result.id
    res += '" type="checkbox"></td>'
    res += '<td class="text-center">' + result.id + '</td>'
    res += '<td class="text-center">' + result.content + '</td>'
    res += '<td><ul>'
    $.each result.answers, (index, value) ->
      if index == result.answer_right
        res += '<li class="correct_answer">' + value + '</li>'
      else
        res += '<li>' + value + '</li>'
    res += '</ul></td>'
    res += '<td class="text-center"><a data-toggle="tooltip" title="Edit" '
    res += 'href="/admin/categories/'
    res += result.category_id+ '/words/' + result.id + '">'
    res += '<i class="glyphicon glyphicon-pencil"></i></a></td>'
    res += '<td class="text-center"><a data-toggle="tooltip" title="Delete"'
    res += 'data-confirm="Are you sure?" rel="nofollow" data-method="delete" '
    res += 'href="/admin/categories/'
    res += result.category_id+ '/words/' + result.id + '">'
    res += '<i class="glyphicon glyphicon-trash"></i></a></td></tr>'
    res

  $('#btnDeleteMultipleWord').click ->
    c = confirm('Are you sure?')
    if c
      $('#formDeleteMultipleWord').submit()

  sizeInputWord = 4
  $('#btnAddWord').on 'click', (e) ->
    e.preventDefault()
    if sizeInputWord < 8
      sizeInputWord++
      $('#tableAddWord').append(newInputWord(sizeInputWord - 1))

  $('#tableAddWord').on 'click', '.btnRemove', ->
    if sizeInputWord > 2
      sizeInputWord--
      $(this).parents('tr').remove()
      setValueRadio()

  setValueRadio = ->
    index = 0
    $('input[name="is_correct"]').each ->
      $(this).val(index)
      index++

  newInputWord = (id) ->
    res = '<tr><td>'
    res += '<input placeholder="Answer" class="form-control" '
    res += 'name="word[word_answers_attributes][' + id + '][content]" '
    res += 'id="word_word_answers_attributes_' + id + '_content" type="text">'
    res += '</td><td>'
    res += '<input name="is_correct" value="' + id + '" '
    res += 'id="word_word_answers_attributes_' + id
    res += '_is_correct_' + id + '" type="radio">'
    res += '</td><td>'
    res += '<a href="#" class="btnRemove">'
    res += '<i class="glyphicon glyphicon-trash"></i>'
    res += '</a></td></tr>'
    res

  $('.radioGroup').click ->
    $('.num_answers').text $('li :checked').size()

  setInterval (->
    tmp = $('#item-headerl').children('img').attr('src')
    $('#item-headerl').children('img').attr 'src',
      $('#item-headerm').children('img').attr('src')
    $('#item-headerm').children('img').attr 'src',
      $('#item-headerr').children('img').attr('src')
    $('#item-headerr').children('img').attr 'src', tmp
    return), 5000

  id = 0
  $('#editCategoryModal').on 'show.bs.modal', (e) ->
    button = $(e.relatedTarget)
    id = button.data('id')
    name = $('#' + id).find('td[id="name"]').html()
    description = $('#' + id).find('td[id="description"]').html().trim()
    $('#editCategoryModal').find('input[id="category_name"]').val name
    $('#editCategoryModal').find('input[id="category_description"]')
      .val description

  $('#editCategoryModal').find('form').submit (e) ->
    e.preventDefault()
    action = $(this).attr('action') + '/' + id
    method = 'PUT'
    data = $(this).serializeArray()
    $.ajax
      url: action
      method: method
      data: data
      dataType: 'json'
      success: (result) ->
        $('#editCategoryModal').modal('toggle')
        alert 'Update successful'
        $('#' + result.id).find('td[id="name"]').html(result.name)
        $('#' + result.id).find('td[id="description"]').html(result.description)
      error: (result) ->
        alert 'Can\'t update category. Check information please'

  id = 0
  sizeInputWordEdit = 0
  $('#editWordModal').on 'show.bs.modal', (e) ->
    button = $(e.relatedTarget)
    id = button.data('id')
    content = $('#' + id).find('td[id="content"]').html()
    answers = []
    $('#' + id + ' ul li').each ->
      answers.push($(this).text().trim())
    sizeArray = answers.length
    $('div[id="editWordModal"]').find('tr').remove()
    sizeInputWordEdit = 0
    while sizeInputWordEdit < sizeArray
      sizeInputWordEdit++
      $('div[id="editWordModal"]').find('#tableAddWord')
        .append(newInputWord(sizeInputWordEdit - 1))
    setValueRadioEdit()
    i = 0
    $(this).find('table input[type="text"]').each ->
      $(this).val(answers[i])
      i++
    $(this).find('input[id="word_content"]').val(content)
    correctAnswer = $('#' + id).find('li[class="correct_answer"]').val()
    correctAnswer = 'input[value="' + correctAnswer + '"]' 
    $(this).find(correctAnswer).prop("checked", true)

  $('#editWordModal').find('form').submit (e) ->
    e.preventDefault()
    action = $(this).attr('action') + '/' + id
    method = 'PUT'
    data = $(this).serializeArray()
    $.ajax
      url: action
      method: method
      data: data
      dataType: 'json'
      success: (result) ->
        $('#editWordModal').modal('toggle')
        alert 'Update successful'
        $('#' + result.id).find('td[id="content"]').html(result.content)
        $('#' + result.id).find('td[id="answers"]')
          .html(answersResult(result.answers, result.answer_right))
      error: (result) ->
        alert 'Can\'t update category. Check information please'

  $('div[id="editWordModal"]').find('#btnAddWord').on 'click', (e) ->
    e.preventDefault()
    if sizeInputWordEdit < 8
      sizeInputWordEdit++
      $('div[id="editWordModal"]').find('#tableAddWord')
        .append(newInputWord(sizeInputWord ))

  $('div[id="editWordModal"]').find('#tableAddWord').on 'click', '.btnRemove',->
    removeInput($(this))

  removeInput = (element) ->
    if sizeInputWordEdit > 2
      sizeInputWordEdit--
      element.parents('tr').remove()
      setValueRadioEdit()

  setValueRadioEdit = ->
    index = 0
    $('div[id="editWordModal"]').find('input[name="is_correct"]').each ->
      $(this).val(index)
      index++

  answersResult = (answers, answerRight) ->
    i = 0
    res = '<ul>'
    answers.forEach (answer) ->
      debugger
      if i == answerRight
        res += '<li class=correct_answer>'
      else
        res += '<li>'
      res +=  answer + '</li>'
      i++
    res += '</ul>'
    return res
