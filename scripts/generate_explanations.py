import os
from fpdf import FPDF

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
LIB_DIR = os.path.join(ROOT, 'lib')
OUT_DIR = os.path.join(ROOT, 'docs')
OUT_MD = os.path.join(OUT_DIR, 'project_explanation.md')
OUT_PDF = os.path.join(OUT_DIR, 'project_explanation.pdf')

os.makedirs(OUT_DIR, exist_ok=True)

def explain_line(line):
    s = line.strip()
    if s == '':
        return 'Blank line'
    if s.startswith('//') or s.startswith('/*') or s.startswith('*'):
        return 'Comment: ' + s.lstrip('/').strip()
    if s.startswith('import'):
        return 'Imports module or package: ' + s
    if s.startswith('part') or s.startswith('export'):
        return 'Library part/export directive: ' + s
    if s.startswith('@'):
        return 'Annotation/Decorator: ' + s
    if s.startswith('class '):
        return 'Class declaration: ' + s
    if ' class ' in s and s.strip().endswith('{'):
        return 'Class declaration (complex): ' + s
    if s.startswith('final ') or s.startswith('const ') or s.startswith('var '):
        return 'Variable declaration: ' + s
    if s.startswith('return '):
        return 'Return statement: ' + s
    if s.startswith('void ') or s.startswith('Future') or s.startswith('Stream'):
        return 'Function/method declaration or async return type: ' + s
    if s.startswith('Widget ') or 'Widget' in s:
        return 'Flutter widget/typed UI code: ' + s
    if 'Scaffold(' in s or 'AppBar(' in s or 'ListView' in s:
        return 'Flutter UI widget usage: ' + s
    if s.startswith('if ') or s.startswith('else') or s.startswith('for ') or s.startswith('while '):
        return 'Control flow statement: ' + s
    if '=>' in s and s.endswith(';'):
        return 'Short arrow function/expression: ' + s
    return 'Code: ' + s

# Collect dart files
dart_files = []
for dirpath, dirnames, filenames in os.walk(LIB_DIR):
    for fn in filenames:
        if fn.endswith('.dart'):
            dart_files.append(os.path.join(dirpath, fn))

dart_files.sort()

# Create markdown first (optional)
with open(OUT_MD, 'w', encoding='utf-8') as md:
    md.write('# Project explanation (line-by-line)\n\n')
    md.write('Files covered: %d\n\n' % len(dart_files))
    for path in dart_files:
        rel = os.path.relpath(path, ROOT).replace('\\', '/')
        md.write('## %s\n\n' % rel)
        with open(path, 'r', encoding='utf-8') as f:
            lines = f.readlines()
        for i, line in enumerate(lines, start=1):
            explan = explain_line(line)
            # escape backticks for markdown
            safe = line.rstrip().replace('`', "\\`")
            md.write('- **L%d**: `%s`  \n  - %s\n' % (i, safe, explan))
        md.write('\n\n')

# Now create a PDF
pdf = FPDF(format='A4')
pdf.set_auto_page_break(auto=True, margin=15)
pdf.add_page()
pdf.set_font('Arial', 'B', 14)
pdf.cell(0, 8, 'Project explanation (line-by-line)', ln=True)
pdf.ln(4)

pdf.set_font('Arial', '', 10)
for path in dart_files:
    rel = os.path.relpath(path, ROOT).replace('\\', '/')
    pdf.set_font('Arial', 'B', 11)
    pdf.cell(0, 6, rel, ln=True)
    pdf.ln(1)
    pdf.set_font('Courier', '', 8)
    with open(path, 'r', encoding='utf-8') as f:
        lines = f.readlines()
    for i, line in enumerate(lines, start=1):
        code = line.rstrip()
        explan = explain_line(line)
        # Write code line
        pdf.multi_cell(0, 4, f'L{i:03d} | {code}')
        # Write explanation in smaller font
        pdf.set_font('Arial', 'I', 8)
        pdf.multi_cell(0, 4, f'    -> {explan}')
        pdf.set_font('Courier', '', 8)
    pdf.ln(2)

pdf.output(OUT_PDF)
print('Generated:', OUT_PDF)
