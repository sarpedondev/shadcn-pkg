#!/bin/bash
set -e

rm -rf build
mkdir build
cd build 
cp ../tailwind.config.js .
cp ../package.json .
cp ../index.css .
cp ../tsconfig.json .
cp ../components.json .
cp -r ../lib .

npm install tailwindcss-animate class-variance-authority clsx tailwind-merge lucide-react

# Make shadcn install all components
npx shadcn@latest add accordion alert alert-dialog aspect-ratio avatar badge breadcrumb button calendar card carousel chart checkbox collapsible command context-menu table dialog drawer dropdown-menu form hover-card input input-otp label menubar navigation-menu pagination popover progress radio-group resizable scroll-area select separator sheet sidebar skeleton slider sonner switch table tabs textarea toast toggle toggle-group tooltip

# Move components out of the ui folder for simplicity
mv components/ui ./comp
rm -rf components
mv comp components

replace_in_files() {
  local dir="$1"

    # Replace "@/lib/utils" with "../lib/utils"
    find "$dir" -type f -name "*.ts" -o -name "*.tsx" -o -name "*.js" -o -name "*.jsx" | \
      while read -r file; do
        sed -i 's|@/lib/utils|../lib/utils|g' "$file"
      done

    # Replace "@/components/ui/*" with "../components/*"
    find "$dir" -type f -name "*.ts" -o -name "*.tsx" -o -name "*.js" -o -name "*.jsx" | \
      while read -r file; do
        sed -i 's|@/components/ui/|../components/|g' "$file"
      done

    # Replace "@/hooks/*" with "../hooks/*"
    find "$dir" -type f -name "*.ts" -o -name "*.tsx" -o -name "*.js" -o -name "*.jsx" | \
      while read -r file; do
        sed -i 's|@/hooks/|../hooks/|g' "$file"
      done
    }

replace_in_files "./components"
replace_in_files "./hooks"

rm components.json
rm index.css
rm -rf node_modules
rm package-lock.json
rm tailwind.config.js
rm tsconfig.json

npm publish

echo "Published!"
