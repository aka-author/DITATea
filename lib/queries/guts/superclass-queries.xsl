<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:dtea="http://itsurim.com/dtea"
    exclude-result-prefixes="dtea xs" version="2.0">


    <!-- 
        Detecting titles
    -->

    <xsl:template match="*" mode="dtea:isTitle" as="xs:boolean">
        <xsl:sequence select="false()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' bookmap/mainbooktitle ')]" mode="dtea:isTitle"
        as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/title ')]" mode="dtea:isTitle" as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:function name="dtea:isTitle" as="xs:boolean">

        <xsl:param name="element"/>

        <xsl:apply-templates select="$element" mode="dtea:isTitle"/>

    </xsl:function>


    <!-- 
        Detecting block elements 
    -->

    <!-- default -->

    <xsl:template match="node()" mode="dtea:isBlock" as="xs:boolean">
        <xsl:sequence select="false()"/>
    </xsl:template>

    <!-- base/dtd/common-elements.mod -->

    <xsl:template match="*[contains(@class, ' topic/data ')]" mode="dtea:isBlock" as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>
    
    <xsl:template match="*[contains(@class, ' topic/desc ')]" mode="dtea:isBlock" as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/div ')]" mode="dtea:isBlock" as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/dl ')]" mode="dtea:isBlock" as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/example ')]" mode="dtea:isBlock" as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/fig ')]" mode="dtea:isBlock" as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/figgroup ')]" mode="dtea:isBlock"
        as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/itemgroup ')]" mode="dtea:isBlock"
        as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/li ')]" mode="dtea:isBlock" as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/lines ')]" mode="dtea:isBlock" as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/linkpool ')]" mode="dtea:isBlock"
        as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/lq ')]" mode="dtea:isBlock" as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/note ')]" mode="dtea:isBlock" as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/ol ')]" mode="dtea:isBlock" as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/p ')]" mode="dtea:isBlock" as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/pre ')]" mode="dtea:isBlock" as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/simpletable ')]" mode="dtea:isBlock"
        as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/ul ')]" mode="dtea:isBlock" as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>
    
    <!-- base/dtd/topic.mod -->
    
    <xsl:template match="*[contains(@class, ' topic/bodydiv ')]" mode="dtea:isBlock" as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>
    
    <xsl:template match="*[contains(@class, ' topic/section ')]" mode="dtea:isBlock" as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>
    
    <xsl:template match="*[contains(@class, ' topic/sectiondiv ')]" mode="dtea:isBlock"
        as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <!-- base/dtd/tblDecl.mod -->

    <xsl:template match="*[contains(@class, ' topic/table ')]" mode="dtea:isBlock" as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/tgroup ')]" mode="dtea:isBlock" as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/title ')]" mode="dtea:isBlock" as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <!-- demix -->

    <xsl:template match="*[contains(@class, ' dtea/demixed ')]" mode="dtea:isBlock"
        as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <!-- func. -->

    <xsl:function name="dtea:isBlock" as="xs:boolean">
        <xsl:param name="node"/>
        <xsl:apply-templates select="$node" mode="dtea:isBlock"/>
    </xsl:function>


    <!-- 
        Detecting lists 
    -->

    <xsl:template match="*" mode="dtea:isListItem" as="xs:boolean">
        <xsl:sequence select="false()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/li ')]" mode="dtea:isListItem" as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/sli ')]" mode="dtea:isListItem" as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:function name="dtea:isListItem" as="xs:boolean">
        <xsl:param name="node"/>
        <xsl:apply-templates select="$node" mode="dtea:isListItem"/>
    </xsl:function>

    <xsl:template match="*" mode="dtea:isList" as="xs:boolean">
        <xsl:sequence select="false()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/ol ')]" mode="dtea:isList" as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/ul ')]" mode="dtea:isList" as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/sl ')]" mode="dtea:isList" as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:function name="dtea:isList" as="xs:boolean">
        <xsl:param name="node"/>
        <xsl:apply-templates select="$node" mode="dtea:isList"/>
    </xsl:function>

    <!-- Entry -->

    <!-- default -->

    <xsl:template match="*" mode="dtea:isTableEntry" as="xs:boolean">
        <xsl:sequence select="false()"/>
    </xsl:template>

    <!-- base/dtd/common-elements.mod -->

    <xsl:template match="*[contains(@class, ' topic/stentry ')]" mode="dtea:isTableEntry"
        as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/ddhd ')]" mode="dtea:isTableEntry"
        as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/dthd ')]" mode="dtea:isTableEntry"
        as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/dd ')]" mode="dtea:isTableEntry" as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/dt ')]" mode="dtea:isTableEntry" as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <!-- base/dtd/tblDecl.mod -->

    <xsl:template match="*[contains(@class, ' topic/entry ')]" mode="dtea:isTableEntry"
        as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <!-- func. -->

    <xsl:function name="dtea:isTableEntry" as="xs:boolean">
        <xsl:param name="element"/>
        <xsl:apply-templates select="$element" mode="dtea:isTableEntry"/>
    </xsl:function>

    <!-- Rows by table parts -->

    <!-- default -->

    <xsl:template match="*" mode="dtea:isTableHeadRow" as="xs:boolean">
        <xsl:sequence select="false()"/>
    </xsl:template>

    <xsl:template match="*" mode="dtea:isTableBodyRow" as="xs:boolean">
        <xsl:sequence select="false()"/>
    </xsl:template>

    <xsl:template match="*" mode="dtea:isTableFootRow" as="xs:boolean">
        <xsl:sequence select="false()"/>
    </xsl:template>

    <xsl:template match="*" mode="dtea:isTableGenericRow" as="xs:boolean">
        <xsl:sequence select="false()"/>
    </xsl:template>

    <!-- base/dtd/common-elements.mod -->

    <xsl:template match="*[contains(@class, ' topic/sthead ')]" mode="dtea:isTableHeadRow"
        as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/strow ')]" mode="dtea:isTableBodyRow"
        as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/dlhead ')]" mode="dtea:isTableHeadRow"
        as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/dlentry ')]" mode="dtea:isTableBodyRow"
        as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <!-- base/dtd/tblDecl.mod -->

    <xsl:template match="*[contains(@class, ' topic/row ')]" mode="dtea:isTableGenericRow"
        as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <!-- func. -->

    <xsl:function name="dtea:isTableHeadRow" as="xs:boolean">
        <xsl:param name="element"/>
        <xsl:apply-templates select="$element" mode="dtea:isTableHeadRow"/>
    </xsl:function>

    <xsl:function name="dtea:isTableBodyRow" as="xs:boolean">
        <xsl:param name="element"/>
        <xsl:apply-templates select="$element" mode="dtea:isTableBodyRow"/>
    </xsl:function>

    <xsl:function name="dtea:isTableFootRow" as="xs:boolean">
        <xsl:param name="element"/>
        <xsl:apply-templates select="$element" mode="dtea:isTableFootRow"/>
    </xsl:function>

    <xsl:function name="dtea:isTableGenericRow" as="xs:boolean">
        <xsl:param name="element"/>
        <xsl:apply-templates select="$element" mode="dtea:isTableGenericRow"/>
    </xsl:function>

    <!-- Any table row -->

    <xsl:template match="*" mode="dtea:isTableRow" as="xs:boolean">
        <xsl:sequence select="false()"/>
    </xsl:template>

    <xsl:template match="*[dtea:isTableHeadRow(.)]" mode="dtea:isTableRow" as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:template match="*[dtea:isTableBodyRow(.)]" mode="dtea:isTableRow" as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:template match="*[dtea:isTableFootRow(.)]" mode="dtea:isTableRow" as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:template match="*[dtea:isTableGenericRow(.)]" mode="dtea:isTableRow" as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:function name="dtea:isTableRow" as="xs:boolean">
        <xsl:param name="element"/>
        <xsl:apply-templates select="$element" mode="dtea:isTableRow"/>
    </xsl:function>

    <!-- Table heads -->

    <!-- default -->

    <xsl:template match="*" mode="dtea:isTableHead" as="xs:boolean">
        <xsl:sequence select="false()"/>
    </xsl:template>

    <!-- base/dtd/tblDecl.mod -->

    <xsl:template match="*[contains(@class, ' topic/thead ')]" mode="dtea:isTableHead"
        as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <!-- func. -->

    <xsl:function name="dtea:isTableHead" as="xs:boolean">
        <xsl:param name="element"/>
        <xsl:apply-templates select="$element" mode="dtea:isTableHead"/>
    </xsl:function>

    <!-- Table bodies -->

    <!-- default -->

    <xsl:template match="*" mode="dtea:isTableBody" as="xs:boolean">
        <xsl:sequence select="false()"/>
    </xsl:template>

    <!-- base/dtd/tblDecl.mod -->

    <xsl:template match="*[contains(@class, ' topic/tbody ')]" mode="dtea:isTableBody"
        as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <!-- func. -->

    <xsl:function name="dtea:isTableBody" as="xs:boolean">
        <xsl:param name="element"/>
        <xsl:apply-templates select="$element" mode="dtea:isTableBody"/>
    </xsl:function>

    <!-- Table footers -->

    <!-- default -->

    <xsl:template match="*" mode="dtea:isTableFoot" as="xs:boolean">
        <xsl:sequence select="false()"/>
    </xsl:template>

    <!-- base/dtd/tblDecl.mod -->

    <xsl:template match="*[contains(@class, ' topic/tfoot ')]" mode="dtea:isTableFoot"
        as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <!-- func. -->

    <xsl:function name="dtea:isTableFoot" as="xs:boolean">
        <xsl:param name="element"/>
        <xsl:apply-templates select="$element" mode="dtea:isTableFoot"/>
    </xsl:function>

    <!-- Tables -->

    <!-- default -->

    <xsl:template match="*" mode="dtea:isTable" as="xs:boolean">
        <xsl:sequence select="false()"/>
    </xsl:template>

    <!-- base/dtd/common-elements.mod -->

    <xsl:template match="*[contains(@class, ' topic/simpletable ')]" mode="dtea:isTable"
        as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/dl ')]" mode="dtea:isTable" as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <!-- base/dtd/tblDecl.mod -->

    <xsl:template match="*" mode="dtea:isColspec" as="xs:boolean">
        <xsl:sequence select="false()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/colspec ')]" mode="dtea:isColspec"
        as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/tgroup ')]" mode="dtea:isTable" as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <!-- func. -->

    <xsl:function name="dtea:isColspec" as="xs:boolean">
        <xsl:param name="element"/>
        <xsl:apply-templates select="$element" mode="dtea:isColspec"/>
    </xsl:function>

    <xsl:function name="dtea:isTable" as="xs:boolean">
        <xsl:param name="element"/>
        <xsl:apply-templates select="$element" mode="dtea:isTable"/>
    </xsl:function>


    <!-- 
        Detecting inline nodes
    -->

    <xsl:template match="comment()" mode="dtea:isInline" as="xs:boolean">
        <xsl:sequence select="false()"/>
    </xsl:template>

    <xsl:template match="text()" mode="dtea:isInline" as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:template match="*" mode="dtea:isInline" as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:template
        match="*[dtea:isMap(.) or dtea:isTopic(.) or dtea:isTopicBlock(.) or dtea:isTitle(.) or dtea:isBlock(.) or dtea:isTableEntry(.) or dtea:isTableRow(.) or dtea:isTableHead(.) or dtea:isTableBody(.) or dtea:isTableFoot(.) or dtea:isColspec(.)]"
        mode="dtea:isInline" as="xs:boolean">
        <xsl:sequence select="false()"/>
    </xsl:template>

    <xsl:function name="dtea:isInline" as="xs:boolean">
        <xsl:param name="node"/>
        <xsl:apply-templates select="$node" mode="dtea:isInline"/>
    </xsl:function>

    <!-- generic blocks -->

    <xsl:template match="*" mode="dtea:isGenericBlock" as="xs:boolean">
        <xsl:sequence select="false()"/>
    </xsl:template>

    <xsl:template
        match="*[dtea:isBlock(.) and not(dtea:isListItem(.) or dtea:isList(.) or dtea:isTable(.))]"
        mode="dtea:isGenericBlock" as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:function name="dtea:isGenericBlock" as="xs:boolean">
        <xsl:param name="node"/>
        <xsl:apply-templates select="$node" mode="dtea:isGenericBlock"/>
    </xsl:function>


    <!-- 
        Detecting topic body elements 
    -->

    <xsl:template match="*" mode="dtea:isBody" as="xs:boolean">
        <xsl:sequence select="false()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/body ')]" mode="dtea:isBody" as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:function name="dtea:isBody" as="xs:boolean">
        <xsl:param name="element"/>
        <xsl:apply-templates select="$element" mode="dtea:isBody"/>
    </xsl:function>


    <!-- 
        Detecting related links blocks
    -->

    <xsl:template match="*" mode="dtea:isRelatedLinksBlock" as="xs:boolean">
        <xsl:sequence select="false()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/related-links ')]"
        mode="dtea:isRelatedLinksBlock" as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:function name="dtea:isRelatedLinksBlock" as="xs:boolean">
        <xsl:param name="element"/>
        <xsl:apply-templates select="$element" mode="dtea:isRelatedLinksBlock"/>
    </xsl:function>


    <!-- 
        Topic components
    -->

    <xsl:template match="*" mode="dtea:isTopicBlock" as="xs:boolean">
        <xsl:sequence select="false()"/>
    </xsl:template>

    <xsl:template match="*[dtea:isTopic(..) and not(dtea:isTopic(.))]" mode="dtea:isTopicBlock"
        as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:function name="dtea:isTopicBlock" as="xs:boolean">
        <xsl:param name="element"/>
        <xsl:apply-templates select="$element" mode="dtea:isTopicBlock"/>
    </xsl:function>


    <!-- 
        Detecting topics 
    -->

    <xsl:template match="node()" mode="dtea:isTopic" as="xs:boolean">
        <xsl:sequence select="false()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/topic ')]" mode="dtea:isTopic" as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:function name="dtea:isTopic" as="xs:boolean">
        
        <xsl:param name="element"/>
        
        <xsl:choose>
            <xsl:when test="not(empty($element))">
                <xsl:apply-templates select="$element" mode="dtea:isTopic"/>        
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="false()"/>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:function>


    <!-- 
        Detecting documents 
    -->

    <xsl:template match="*" mode="dtea:isMap" as="xs:boolean">
        <xsl:sequence select="false()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' map/map ')]" mode="dtea:isMap" as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:function name="dtea:isMap" as="xs:boolean">
        <xsl:param name="element"/>
        <xsl:apply-templates select="$element" mode="dtea:isMap"/>
    </xsl:function>


    <!-- 
        Detectig an element's superclass
    -->

    <xsl:template match="*" mode="dtea:superclass">

        <xsl:variable name="options" as="xs:string*">

            <xsl:if test="dtea:isBlock(.)">
                <xsl:value-of select="'block'"/>
            </xsl:if>

            <xsl:if test="dtea:isListItem(.)">
                <xsl:value-of select="'listitem'"/>
            </xsl:if>

            <xsl:if test="dtea:isList(.)">
                <xsl:value-of select="'list'"/>
            </xsl:if>

            <xsl:if test="dtea:isTableEntry(.)">
                <xsl:value-of select="'table_entry'"/>
            </xsl:if>

            <xsl:if test="dtea:isTableRow(.)">
                <xsl:value-of select="'table_row'"/>
            </xsl:if>

            <xsl:if test="dtea:isTableHead(.)">
                <xsl:value-of select="'table_head'"/>
            </xsl:if>

            <xsl:if test="dtea:isTableBody(.)">
                <xsl:value-of select="'table_body'"/>
            </xsl:if>

            <xsl:if test="dtea:isTableFoot(.)">
                <xsl:value-of select="'table_foot'"/>
            </xsl:if>

            <xsl:if test="dtea:isTable(.)">
                <xsl:value-of select="'table'"/>
            </xsl:if>

            <xsl:if test="dtea:isTopicBlock(.)">
                <xsl:value-of select="'topic_block'"/>
            </xsl:if>

            <xsl:if test="dtea:isTopic(.)">
                <xsl:value-of select="'struct_node'"/>
            </xsl:if>

            <xsl:if test="dtea:isMap(.)">
                <xsl:value-of select="'struct_node'"/>
            </xsl:if>

        </xsl:variable>

        <xsl:variable name="superclasses" select="normalize-space(string-join($options, ' '))"/>

        <xsl:value-of select="
                if ($superclasses != '') then
                    $superclasses
                else
                    'inline'"/>

    </xsl:template>

    <xsl:function name="dtea:superclass">

        <xsl:param name="element"/>

        <xsl:apply-templates select="$element" mode="dtea:superclass"/>

    </xsl:function>

</xsl:stylesheet>