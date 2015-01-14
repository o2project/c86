"use strict";

var dictionaryItems = require("technical-word-rules");

/**
 * @param {RuleContext} context
 */
module.exports = function(context) {
  var exports = {};

  exports[context.Syntax.Str] = function(node) {
    var text = context.getSource(node);

    for (var i = 0, l = dictionaryItems.length; i < l; i++) {
      var dictionary = dictionaryItems[i];
      var query = new RegExp(dictionary.pattern, dictionary.flag);
      var match = query.exec(text);

      if (!match) {
        continue;
      }

      var matchedString = match[0];

      if (matchedString === 'git'         || /* 参考資料に入門gitがあるため */
          /[ァ-ヶ]・/.test(matchedString) || /* 参考資料にシュタインズ・ゲート公式資料集があるため */
          matchedString === '？'             /* 行末の？が弾かれるがなぜか分からないため */) {
        continue;
      }

      // s/Web/Web/iは大文字小文字無視してWebに変換したいという意味に対応する
      if (dictionary.flag != null) {
        var strictQuery = new RegExp(dictionary.pattern);
        var isStrictMatch = strictQuery.test(match[0]);
        // /Web/i でマッチするけど、 /Web/ でマッチするならそれは除外する
        if (isStrictMatch) {
          continue;
        }
      }
      // [start, end]
      var matchedStartIndex = match.index + 1;
      var expected = matchedString.replace(query, dictionary.expected);
      // line, column
      context.report(node, (new context.RuleError(matchedString + " => " + expected, matchedStartIndex)));
    }
  };

  return exports;
};
