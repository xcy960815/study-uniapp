/* eslint-disable no-console */
'use strict';

const ruleNameToChinese = {
  'type-empty': 'type(类型)不能为空',
  'type-case': 'type(类型)大小写不符合规范',
  'scope-empty': 'scope(范围)不能为空',
  'scope-case': 'scope(范围)大小写不符合规范',
  'subject-empty': 'subject(描述)不能为空',
  'subject-case': 'subject(描述)大小写不符合规范',
  'subject-max-length': 'subject(描述)长度超过最大限制',
  'subject-min-length': 'subject(描述)长度小于最小限制',
  'header-max-length': '标题长度超过最大限制',
  'header-case': '标题大小写不符合规范',
  'body-empty': '正文不能为空',
  'body-max-line-length': '正文单行长度超过最大限制',
  'footer-empty': '页脚不能为空',
  'footer-max-line-length': '页脚单行长度超过最大限制',
};

function mapMessageToChinese(message, name) {
  const cn = ruleNameToChinese[name];
  if (cn) return cn;
  // Fallback: keep English but prepend Chinese说明
  return `不符合规范: ${message}`;
}

module.exports = function formatChinese(payload) {
  // commitlint passes either an array of reports or an object { valid, errorCount, warningCount, results: Report[] }
  let reports = [];
  if (payload && Array.isArray(payload.results)) {
    reports = payload.results;
  } else if (Array.isArray(payload)) {
    reports = payload;
  } else if (payload) {
    reports = [payload];
  }

  let totalErrors = 0;
  let totalWarnings = 0;
  const lines = [];

  for (const report of reports) {
    if (!report) continue;
    const {input, errors = [], warnings = []} = report;
    if (input) {
      lines.push(`输入(commit message): ${input}`);
    }
    for (const err of errors) {
      const msg = mapMessageToChinese(err.message, err.name);
      lines.push(`✖ 错误: ${msg} [${err.name}]`);
    }
    for (const warn of warnings) {
      const msg = mapMessageToChinese(warn.message, warn.name);
      lines.push(`⚠ 警告: ${msg} [${warn.name}]`);
    }
    totalErrors += errors.length;
    totalWarnings += warnings.length;
  }

  if (totalErrors === 0 && totalWarnings === 0) {
    return '';
  }

  lines.push('');
  lines.push(`共发现 ${totalErrors} 个错误, ${totalWarnings} 个警告`);
  lines.push('规范文档: https://github.com/conventional-changelog/commitlint');

  return lines.join('\n');
};


