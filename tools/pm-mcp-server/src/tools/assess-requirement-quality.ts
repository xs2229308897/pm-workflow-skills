interface QualityScore {
  overall_score: number;
  breakdown: {
    id_coverage: number;
    description_quality: number;
    priority_distribution: number;
    acceptance_criteria: number;
    module_balance: number;
  };
  suggestions: string[];
}

export function assessRequirementQuality(requirements: string): QualityScore {
  const suggestions: string[] = [];
  const lines = requirements.split('\n');

  // 检测需求条目（以 M\d+-\d+ 或数字编号开头的行）
  const reqPattern = /^[\s-*]*M?\d+[-.]\d+|^[\s-*]*\d+\.\d+/;
  const reqLines = lines.filter(l => reqPattern.test(l.trim()));

  // ID 覆盖度：检查是否有编号
  const idScore = reqLines.length > 0 ? 100 : 0;
  if (idScore === 0) suggestions.push('建议为每个需求添加编号（如 M1-01 格式）');

  // 描述质量：检查是否有优先级和验收标准
  let descScore = 80;
  const hasPriority = /优先级[：:]\s*(高|中|低)|\b(高|中|低)优先级/.test(requirements);
  if (!hasPriority) {
    descScore -= 20;
    suggestions.push('建议为每个需求标注优先级（高/中/低）');
  }

  const hasAcceptance = /验收标准|验收条件|完成标准/.test(requirements);
  if (!hasAcceptance) {
    descScore -= 20;
    suggestions.push('建议为每个需求添加验收标准');
  }

  // 优先级分布
  const highCount = (requirements.match(/高/g) || []).length;
  const medCount = (requirements.match(/中/g) || []).length;
  const lowCount = (requirements.match(/低/g) || []).length;
  const total = highCount + medCount + lowCount;
  let priorityScore = 100;
  if (total > 0 && highCount / total > 0.7) {
    priorityScore = 50;
    suggestions.push('高优先级需求占比过高（>70%），建议重新评估优先级分布');
  }

  // 模块覆盖：检查是否有模块分组
  const modulePattern = /#{1,3}\s*.+模块|#{1,3}\s*M\d+/;
  const hasModules = modulePattern.test(requirements);
  const moduleScore = hasModules ? 100 : 50;
  if (!hasModules) suggestions.push('建议按模块/功能分组组织需求');

  // 综合评分
  const overall = Math.round(
    idScore * 0.15 + descScore * 0.3 + priorityScore * 0.25 + moduleScore * 0.3
  );

  return {
    overall_score: overall,
    breakdown: {
      id_coverage: idScore,
      description_quality: descScore,
      priority_distribution: priorityScore,
      acceptance_criteria: hasAcceptance ? 100 : 0,
      module_balance: moduleScore
    },
    suggestions
  };
}
