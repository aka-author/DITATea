<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xat="http://itsurim.com/xatool" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:dtea="http://itsurim.com/dtea" exclude-result-prefixes="dtea xat xs" version="2.0">


    <xsl:import href="../../../xatool/html/xsl-2.0/html.xsl"/>

    <xsl:import href="../../queries/queries.xsl"/>


    <!-- 
        Extracting attributes values from @outputclass 
    -->

    <xsl:template match="*" mode="dtea:hasParsableOutputclass" as="xs:boolean">

        <xsl:variable name="attrPattern" as="xs:string">
            <![CDATA[^(\s*[a-zA-Z_:][-a-zA-Z0-9_:.]*\s*=\s*"[^"]*"\s*)+$|^(\s*[a-zA-Z_:][-a-zA-Z0-9_:.]*\s*=\s*'[^']*'\s*)+$]]>
        </xsl:variable>

        <xsl:sequence select="matches(@outputclass, normalize-space($attrPattern))"/>

    </xsl:template>

    <xsl:function name="dtea:hasParsableOutputclass" as="xs:boolean">

        <xsl:param name="element"/>

        <xsl:apply-templates select="$element" mode="dtea:hasParsableOutputclass"/>

    </xsl:function>


    <xsl:function name="dtea:html.splitCodeSnippetByAttrs" as="element()*">

        <xsl:param name="attrsCodeSnippet"/>

        <xsl:variable name="attrsRegex" as="xs:string">
            <![CDATA[([a-zA-Z_:][-a-zA-Z0-9_:.]*)(\s*=\s*)("([^"]*)"|'([^']*)')]]>
        </xsl:variable>

        <attrs>
            <xsl:analyze-string select="$attrsCodeSnippet" regex="{normalize-space($attrsRegex)}">

                <xsl:matching-substring>

                    <xsl:variable name="attrName" select="regex-group(1)"/>
                    <xsl:variable name="rawAttrVal" select="regex-group(3)"/>
                    <xsl:variable name="attrValLen" select="string-length($rawAttrVal) - 2"/>

                    <attr name="{$attrName}">
                        <xsl:value-of select="substring($rawAttrVal, 2, $attrValLen)"/>
                    </attr>

                </xsl:matching-substring>

            </xsl:analyze-string>
        </attrs>

    </xsl:function>


    <xsl:template match="*" mode="dtea:attrValueFromOutputclass">

        <xsl:param name="attrName"/>

        <xsl:variable name="attrs"
            select="dtea:html.splitCodeSnippetByAttrs(normalize-space(@outputclass))"/>

        <xsl:value-of select="$attrs//attr[@name = $attrName]"/>

    </xsl:template>

    <xsl:function name="dtea:getAttrFromOutputclass">

        <xsl:param name="element"/>
        <xsl:param name="attrName"/>

        <xsl:apply-templates select="$element" mode="dtea:attrValueFromOutputclass">
            <xsl:with-param name="attrName" select="$attrName"/>
        </xsl:apply-templates>

    </xsl:function>


    <!-- 
        Producing @id
    -->
    
    <xsl:template match="*[dtea:getAttrFromOutputclass(., 'id') != '']" mode="dtea:outId">
        <xsl:value-of select="dtea:getAttrFromOutputclass(., 'id')"/>
    </xsl:template>
        
    <xsl:template match="*" mode="dtea:html.outIdAttr">    
        <xsl:copy-of select="xat:usefulAttr('id', dtea:outId(.))"/> 
    </xsl:template>


    <xsl:template match="*" mode="dtea:html.idAttr">

        <xsl:param name="directId" select="''"/>

        <xsl:choose>

            <xsl:when test="$directId != ''">
                <xsl:attribute name="id" select="$directId"/>
            </xsl:when>

            <xsl:otherwise>
                <xsl:apply-templates select="." mode="dtea:html.outIdAttr"/>
            </xsl:otherwise>

        </xsl:choose>

    </xsl:template>


    <!-- 
        Producing output attributes
    -->

    <!-- @class -->
    
    <xsl:template match="*" mode="dtea:css.classNamesFromSuperclass">
        <xsl:value-of select="dtea:superclass(.)"/>
    </xsl:template>

    <xsl:template match="*" mode="dtea:css.classNamesFromDITADomains">

        <xsl:variable name="cssClassNames" as="xs:string*">
            <xsl:analyze-string select="replace(@class, '^[\+\-]\s+', '')" regex="\S+">
                <xsl:matching-substring>
                    <xsl:value-of select="concat('dita__', substring-before(., '/'))"/>
                </xsl:matching-substring>
            </xsl:analyze-string>
        </xsl:variable>

        <xsl:value-of select="string-join($cssClassNames, ' ')"/>

    </xsl:template>

    <xsl:template match="*" mode="dtea:css.classNamesFromDITAElements">

        <xsl:variable name="cssClassNames" as="xs:string*">
            <xsl:analyze-string select="replace(@class, '^[\+\-]\s+', '')" regex="\S+">
                <xsl:matching-substring>
                    <xsl:value-of select="substring-after(., '/')"/>
                </xsl:matching-substring>
            </xsl:analyze-string>
        </xsl:variable>

        <xsl:value-of select="string-join($cssClassNames, ' ')"/>

    </xsl:template>

    <xsl:template match="*" mode="dtea:css.classNamesFromDITASpec">

        <xsl:variable name="cssClassNames" as="xs:string*">
            <xsl:apply-templates select="." mode="dtea:css.classNamesFromDITADomains"/>
            <xsl:apply-templates select="." mode="dtea:css.classNamesFromDITAElements"/>
        </xsl:variable>

        <xsl:value-of select="string-join($cssClassNames, ' ')"/>

    </xsl:template>


    <xsl:template match="*" mode="dtea:css.classNamesFromOutputclass">

        <xsl:choose>

            <xsl:when test="dtea:hasParsableOutputclass(.)">
                <xsl:value-of select="dtea:getAttrFromOutputclass(., 'class')"/>
            </xsl:when>

            <xsl:otherwise>
                <xsl:value-of select="@outputclass"/>
            </xsl:otherwise>

        </xsl:choose>

    </xsl:template>

    
    <xsl:template match="*" mode="dtea:css.classNamesSpecific"/>
    

    <xsl:template match="*" mode="dtea:css.afterClassNames">

        <xsl:variable name="rawClassNamesOfPrec" as="xs:string*">
            <xsl:apply-templates select="preceding-sibling::*[1]" mode="dtea:css.classNamesFromSuperclass"/>
            <xsl:apply-templates select="preceding-sibling::*[1]" mode="dtea:css.classNamesFromDITAElements"/>
            <xsl:apply-templates select="preceding-sibling::*[1]" mode="dtea:css.classNamesFromOutputclass"/>
            <xsl:apply-templates select="preceding-sibling::*[1]" mode="dtea:css.classNamesSpecific"/>
        </xsl:variable>

        <xsl:variable name="classNamesOfPrec" select="string-join($rawClassNamesOfPrec, ' ')"/>

        <xsl:if test="contains($classNamesOfPrec, 'block ')">

            <xsl:variable name="afterClassNames" as="xs:string*">
                <xsl:for-each select="tokenize(normalize-space($classNamesOfPrec), ' ')">
                    <xsl:if test="not(starts-with(., 'after__'))">
                        <xsl:value-of select="concat('after__', .)"/>
                    </xsl:if>
                </xsl:for-each>
            </xsl:variable>

            <xsl:value-of select="$afterClassNames"/>

        </xsl:if>

    </xsl:template>


    <xsl:template match="*" mode="dtea:css.classNames">

        <xsl:param name="insertCSSClassNames" select="''"/>

        <xsl:variable name="cssClassNames" as="xs:string*">
            <xsl:apply-templates select="." mode="dtea:css.classNamesFromSuperclass"/>
            <xsl:apply-templates select="." mode="dtea:css.classNamesFromDITASpec"/>
            <xsl:apply-templates select="." mode="dtea:css.classNamesFromOutputclass"/>
            <xsl:apply-templates select="." mode="dtea:css.classNamesSpecific"/>
            <xsl:apply-templates select="." mode="dtea:css.afterClassNames"/>
            <xsl:value-of select="$insertCSSClassNames"/>
        </xsl:variable>

        <xsl:value-of select="normalize-space(string-join($cssClassNames, ' '))"/>

    </xsl:template>


    <xsl:template match="*" mode="dtea:html.classAttr">

        <xsl:param name="directCSSClassNames" select="''"/>
        <xsl:param name="insertCSSClassNames" select="''"/>

        <xsl:attribute name="class">

            <xsl:choose>

                <xsl:when test="$directCSSClassNames != ''">
                    <xsl:value-of select="$directCSSClassNames"/>
                </xsl:when>

                <xsl:otherwise>
                    <xsl:apply-templates select="." mode="dtea:css.classNames">
                        <xsl:with-param name="insertCSSClassNames" select="$insertCSSClassNames"/>
                    </xsl:apply-templates>
                </xsl:otherwise>

            </xsl:choose>

        </xsl:attribute>

    </xsl:template>

    <!-- Assembling styles and @style attrs. -->

    <xsl:template match="*" mode="dtea:css.styleItems" as="xs:string*"/>
    
    <xsl:template match="*" mode="dtea:css.style" as="xs:string">
        
        <xsl:variable name="styleItems" as="xs:string*">
            <xsl:apply-templates select="." mode="dtea:css.styleItems"/>
        </xsl:variable>
        
        <xsl:value-of select="xat:css.style($styleItems)"/>
        
    </xsl:template>

    <xsl:template match="*" mode="dtea:html.styleAttr">
        
        <xsl:variable name="style">
            <xsl:apply-templates select="." mode="dtea:css.style"/>
        </xsl:variable>
        
        <xsl:copy-of select="xat:usefulAttr('style', $style)"/>
        
    </xsl:template>

    <!-- Assembling attributes specific for an element -->

    <xsl:template match="*" mode="dtea:specificAttrs"/>

    <!-- Assembling attributes based on the sourcr @outputclass -->

    <xsl:template match="*" mode="dtea:html.attrsFromOutputclass">

        <xsl:if test="dtea:hasParsableOutputclass(.)">

            <xsl:variable name="attrs" as="element()*">
                <xsl:copy-of select="dtea:html.splitCodeSnippetByAttrs(normalize-space(@outputclass))"/>
            </xsl:variable>

            <xsl:for-each select="$attrs//attr">
                <xsl:if test="not(@name = ('id', 'class'))">
                    <xsl:attribute name="{@name}" select="."/>
                </xsl:if>
            </xsl:for-each>

        </xsl:if>

    </xsl:template>

    <!-- Entire output attributes assembly -->
                                 
    <xsl:template match="*" mode="dtea:outAttrs">

        <xsl:param name="directId" select="''"/>
        <xsl:param name="directCSSClassNames" select="''"/>
        <xsl:param name="insertCSSClassNames" select="''"/>

        <!-- obsolete -->
        <xsl:param name="defaultCSSClassName" select="''"/>
        <xsl:param name="extraCSSClassName" select="''"/>
        <!-- /obsolete -->

        <xsl:variable name="dcn">
            <xsl:choose>
                <xsl:when test="$defaultCSSClassName != ''">
                    <xsl:value-of select="$defaultCSSClassName"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$directCSSClassNames"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="icn">
            <xsl:choose>
                <xsl:when test="$extraCSSClassName != ''">
                    <xsl:value-of select="$extraCSSClassName"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$insertCSSClassNames"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:apply-templates select="." mode="dtea:html.idAttr">
            <xsl:with-param name="directId" select="$directId"/>
        </xsl:apply-templates>

        <xsl:apply-templates select="." mode="dtea:html.classAttr">
            <xsl:with-param name="directCSSClassNames" select="$dcn"/>
            <xsl:with-param name="insertCSSClassNames" select="$icn"/>
        </xsl:apply-templates>

        <xsl:apply-templates select="." mode="dtea:html.styleAttr"/>

        <xsl:apply-templates select="." mode="dtea:specificAttrs"/>

        <xsl:apply-templates select="." mode="dtea:html.attrsFromOutputclass"/>

    </xsl:template>

</xsl:stylesheet>
