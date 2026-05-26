interface Entity {
  name: string;
  fields: Array<{ name: string; type: string; pk: boolean }>;
}

interface Relationship {
  from: string;
  to: string;
  type: string;
}

export function generateErDiagram(dataModel: string): string {
  const entities: Entity[] = [];
  const relationships: Relationship[] = [];

  // 解析表定义（匹配 Markdown 标题中的表名或 CREATE TABLE）
  const tablePattern = /(?:###?\s*`?(\w+)`?\s*(?:表|table)|CREATE\s+TABLE\s+`?(\w+)`?)/gi;
  let tableMatch;
  const tableNames: string[] = [];

  while ((tableMatch = tablePattern.exec(dataModel)) !== null) {
    const name = tableMatch[1] || tableMatch[2];
    tableNames.push(name);
  }

  // 为每个表解析字段
  for (const tableName of tableNames) {
    const fields: Array<{ name: string; type: string; pk: boolean }> = [];
    const tableStart = dataModel.indexOf(tableName);
    if (tableStart === -1) continue;

    const nextTableStart = tableNames.indexOf(tableName) + 1 < tableNames.length
      ? dataModel.indexOf(tableNames[tableNames.indexOf(tableName) + 1])
      : dataModel.length;
    const tableSection = dataModel.substring(tableStart, nextTableStart);

    // 解析字段行（Markdown 表格行）
    const fieldPattern = /\|\s*`?(\w+)`?\s*\|\s*`?(\w+(?:\([^)]+\))?)`?\s*\|/g;
    let fieldMatch;
    while ((fieldMatch = fieldPattern.exec(tableSection)) !== null) {
      const fieldName = fieldMatch[1];
      const fieldType = fieldMatch[2];
      if (['字段名', 'field', 'name', 'column'].includes(fieldName.toLowerCase())) continue;
      fields.push({
        name: fieldName,
        type: fieldType,
        pk: /id$/i.test(fieldName)
      });
    }

    if (fields.length > 0) {
      entities.push({ name: tableName, fields });
    }
  }

  // 解析关系（外键或显式关系描述）
  const fkPattern = /(\w+)\s*(?:->|→|关联|外键)\s*(\w+)/gi;
  let fkMatch;
  while ((fkMatch = fkPattern.exec(dataModel)) !== null) {
    relationships.push({
      from: fkMatch[1],
      to: fkMatch[2],
      type: 'many-to-one'
    });
  }

  // 生成 Mermaid ER 图
  let mermaid = 'erDiagram\n';

  for (const entity of entities) {
    mermaid += `  ${entity.name} {\n`;
    for (const field of entity.fields) {
      const pkMarker = field.pk ? ' PK' : '';
      mermaid += `    ${field.type} ${field.name}${pkMarker}\n`;
    }
    mermaid += `  }\n`;
  }

  if (relationships.length > 0) {
    mermaid += '\n';
    for (const rel of relationships) {
      mermaid += `  ${rel.from}||--o{ ${rel.to} : "has"\n`;
    }
  }

  if (entities.length === 0) {
    return '// 未能从数据模型中解析出实体定义，请检查输入格式';
  }

  return mermaid;
}
