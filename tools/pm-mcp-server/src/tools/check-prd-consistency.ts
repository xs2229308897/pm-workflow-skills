interface ConsistencyResult {
  consistent: boolean;
  issues: string[];
  warnings: string[];
}

export function checkPrdConsistency(prd: string): ConsistencyResult {
  const issues: string[] = [];
  const warnings: string[] = [];

  // 检查必要章节是否存在
  const requiredSections = ['执行摘要', '业务背景', '功能设计', '数据模型', '非功能'];
  for (const section of requiredSections) {
    if (!prd.includes(section)) {
      issues.push(`缺少必要章节：${section}`);
    }
  }

  // 检查占位符
  const placeholders = prd.match(/(TODO|TBD|待定|待补充|占位)/gi);
  if (placeholders && placeholders.length > 0) {
    issues.push(`发现 ${placeholders.length} 个占位符未填充：${[...new Set(placeholders)].join('、')}`);
  }

  // 检查数据模型与功能设计的一致性
  const tablePattern = /\|\s*\w+\s*\|.*?\|/g;
  const tables = prd.match(tablePattern);
  if (!tables || tables.length < 3) {
    warnings.push('数据模型章节可能不完整（表格数量较少）');
  }

  // 检查是否有空章节
  const sectionPattern = /#{1,3}\s+.+\n\n(?=#{|\s*$)/gm;
  const emptySections = prd.match(sectionPattern);
  if (emptySections) {
    warnings.push(`发现 ${emptySections.length} 个可能为空的章节`);
  }

  return {
    consistent: issues.length === 0,
    issues,
    warnings
  };
}
